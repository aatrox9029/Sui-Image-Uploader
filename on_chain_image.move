module image_nft::on_chain_image {
    use std::string::String;
    use std::vector;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    const E_NOT_UPLOADER: u64 = 1;
    const E_EMPTY_DATA: u64 = 2;
    const E_DATA_TOO_LARGE: u64 = 3;
    const E_EMPTY_CHUNK: u64 = 4;
    const E_CHUNK_TOO_LARGE: u64 = 5;
    const E_BAD_ENCRYPT_META: u64 = 6;
    const E_WEAK_PASSWORD_KDF: u64 = 7;
    const E_BAD_NONCE: u64 = 8;

    const MAX_IMAGE_BYTES: u64 = 8_000_000;
    const MAX_CHUNK_BYTES: u64 = 16_000;
    const MIN_SALT_BYTES: u64 = 16;
    const REQUIRED_NONCE_BYTES: u64 = 12;
    const MIN_KDF_ROUNDS: u64 = 200_000;

    public struct Image has key, store {
        id: UID,
        uploader: address,
        data: vector<u8>,
        mime_type: String,
        description: String,
        is_encrypted: bool,
        kdf_salt: vector<u8>,
        kdf_rounds: u64,
        nonce: vector<u8>,
        size_bytes: u64,
        chunk_count: u64,
        created_at_ms: u64,
    }

    public struct UploadSession has key, store {
        id: UID,
        uploader: address,
        data: vector<u8>,
        mime_type: String,
        description: String,
        is_encrypted: bool,
        kdf_salt: vector<u8>,
        kdf_rounds: u64,
        nonce: vector<u8>,
        size_bytes: u64,
        chunk_count: u64,
        created_at_ms: u64,
    }

    public struct UploadStarted has copy, drop {
        session_id: address,
        uploader: address,
        encrypted: bool,
    }

    public struct ChunkAppended has copy, drop {
        session_id: address,
        uploader: address,
        chunk_size: u64,
        total_size: u64,
        chunk_count: u64,
    }

    public struct UploadCanceled has copy, drop {
        session_id: address,
        uploader: address,
        total_size: u64,
        chunk_count: u64,
    }

    public struct ImageUploaded has copy, drop {
        id: address,
        uploader: address,
        encrypted: bool,
        size_bytes: u64,
        chunk_count: u64,
    }

    public struct ImageDeleted has copy, drop {
        id: address,
        uploader: address,
    }

    public fun upload_image(
        data: vector<u8>,
        mime_type: String,
        description: String,
        ctx: &mut TxContext,
    ): Image {
        let size_bytes = vector::length(&data);
        assert!(size_bytes > 0, E_EMPTY_DATA);
        assert!(size_bytes <= MAX_IMAGE_BYTES, E_DATA_TOO_LARGE);

        let uploader = tx_context::sender(ctx);
        let image = Image {
            id: object::new(ctx),
            uploader,
            data,
            mime_type,
            description,
            is_encrypted: false,
            kdf_salt: vector::empty<u8>(),
            kdf_rounds: 0,
            nonce: vector::empty<u8>(),
            size_bytes,
            chunk_count: 1,
            created_at_ms: tx_context::epoch_timestamp_ms(ctx),
        };

        event::emit(ImageUploaded {
            id: object::id_address(&image),
            uploader,
            encrypted: false,
            size_bytes,
            chunk_count: 1,
        });

        image
    }

    public fun upload_image_encrypted(
        data: vector<u8>,
        mime_type: String,
        description: String,
        kdf_salt: vector<u8>,
        kdf_rounds: u64,
        nonce: vector<u8>,
        ctx: &mut TxContext,
    ): Image {
        let size_bytes = vector::length(&data);
        assert!(size_bytes > 0, E_EMPTY_DATA);
        assert!(size_bytes <= MAX_IMAGE_BYTES, E_DATA_TOO_LARGE);
        assert!(vector::length(&kdf_salt) >= MIN_SALT_BYTES, E_BAD_ENCRYPT_META);
        assert!(kdf_rounds >= MIN_KDF_ROUNDS, E_WEAK_PASSWORD_KDF);
        assert!(vector::length(&nonce) == REQUIRED_NONCE_BYTES, E_BAD_NONCE);

        let uploader = tx_context::sender(ctx);
        let image = Image {
            id: object::new(ctx),
            uploader,
            data,
            mime_type,
            description,
            is_encrypted: true,
            kdf_salt,
            kdf_rounds,
            nonce,
            size_bytes,
            chunk_count: 1,
            created_at_ms: tx_context::epoch_timestamp_ms(ctx),
        };

        event::emit(ImageUploaded {
            id: object::id_address(&image),
            uploader,
            encrypted: true,
            size_bytes,
            chunk_count: 1,
        });

        image
    }

    public fun start_upload(
        mime_type: String,
        description: String,
        is_encrypted: bool,
        kdf_salt: vector<u8>,
        kdf_rounds: u64,
        nonce: vector<u8>,
        ctx: &mut TxContext,
    ): UploadSession {
        if (is_encrypted) {
            assert!(vector::length(&kdf_salt) >= MIN_SALT_BYTES, E_BAD_ENCRYPT_META);
            assert!(kdf_rounds >= MIN_KDF_ROUNDS, E_WEAK_PASSWORD_KDF);
            assert!(vector::length(&nonce) == REQUIRED_NONCE_BYTES, E_BAD_NONCE);
        } else {
            assert!(vector::length(&kdf_salt) == 0, E_BAD_ENCRYPT_META);
            assert!(kdf_rounds == 0, E_BAD_ENCRYPT_META);
            assert!(vector::length(&nonce) == 0, E_BAD_ENCRYPT_META);
        };

        let uploader = tx_context::sender(ctx);
        let session = UploadSession {
            id: object::new(ctx),
            uploader,
            data: vector::empty<u8>(),
            mime_type,
            description,
            is_encrypted,
            kdf_salt,
            kdf_rounds,
            nonce,
            size_bytes: 0,
            chunk_count: 0,
            created_at_ms: tx_context::epoch_timestamp_ms(ctx),
        };

        event::emit(UploadStarted {
            session_id: object::id_address(&session),
            uploader,
            encrypted: is_encrypted,
        });

        session
    }

    public fun append_chunk(session: &mut UploadSession, chunk: vector<u8>, ctx: &TxContext) {
        assert!(session.uploader == tx_context::sender(ctx), E_NOT_UPLOADER);

        let chunk_size = vector::length(&chunk);
        assert!(chunk_size > 0, E_EMPTY_CHUNK);
        assert!(chunk_size <= MAX_CHUNK_BYTES, E_CHUNK_TOO_LARGE);

        let total_size = session.size_bytes + chunk_size;
        assert!(total_size <= MAX_IMAGE_BYTES, E_DATA_TOO_LARGE);

        vector::append(&mut session.data, chunk);
        session.size_bytes = total_size;
        session.chunk_count = session.chunk_count + 1;

        event::emit(ChunkAppended {
            session_id: object::id_address(session),
            uploader: session.uploader,
            chunk_size,
            total_size,
            chunk_count: session.chunk_count,
        });
    }

    public fun finalize_upload(session: UploadSession, ctx: &mut TxContext): Image {
        let UploadSession {
            id: session_id,
            uploader,
            data,
            mime_type,
            description,
            is_encrypted,
            kdf_salt,
            kdf_rounds,
            nonce,
            size_bytes,
            chunk_count,
            created_at_ms,
        } = session;

        assert!(uploader == tx_context::sender(ctx), E_NOT_UPLOADER);
        assert!(size_bytes > 0, E_EMPTY_DATA);

        object::delete(session_id);

        let image = Image {
            id: object::new(ctx),
            uploader,
            data,
            mime_type,
            description,
            is_encrypted,
            kdf_salt,
            kdf_rounds,
            nonce,
            size_bytes,
            chunk_count,
            created_at_ms,
        };

        event::emit(ImageUploaded {
            id: object::id_address(&image),
            uploader,
            encrypted: is_encrypted,
            size_bytes,
            chunk_count,
        });

        image
    }

    public fun cancel_upload(session: UploadSession, ctx: &TxContext) {
        let session_id_addr = object::id_address(&session);
        assert!(session.uploader == tx_context::sender(ctx), E_NOT_UPLOADER);

        let UploadSession {
            id,
            uploader,
            data: _,
            mime_type: _,
            description: _,
            is_encrypted: _,
            kdf_salt: _,
            kdf_rounds: _,
            nonce: _,
            size_bytes,
            chunk_count,
            created_at_ms: _,
        } = session;

        object::delete(id);

        event::emit(UploadCanceled {
            session_id: session_id_addr,
            uploader,
            total_size: size_bytes,
            chunk_count,
        });
    }

    public fun set_description(image: &mut Image, description: String, ctx: &TxContext) {
        assert!(image.uploader == tx_context::sender(ctx), E_NOT_UPLOADER);
        image.description = description;
    }

    public fun delete_image(image: Image, ctx: &TxContext) {
        let image_id_addr = object::id_address(&image);
        assert!(image.uploader == tx_context::sender(ctx), E_NOT_UPLOADER);

        let Image {
            id,
            uploader,
            data: _,
            mime_type: _,
            description: _,
            is_encrypted: _,
            kdf_salt: _,
            kdf_rounds: _,
            nonce: _,
            size_bytes: _,
            chunk_count: _,
            created_at_ms: _,
        } = image;

        object::delete(id);

        event::emit(ImageDeleted {
            id: image_id_addr,
            uploader,
        });
    }
}
