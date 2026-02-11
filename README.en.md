# Sui Secure Chunked Image Uploader

A Sui image upload dApp with:
- chunked on-chain upload
- near-lossless client-side compression
- optional password encryption (AES-256-GCM)
- image lookup by Object ID
- OKX dedicated wallet flow + wallet-standard support
- multilingual UI (Traditional Chinese, Simplified Chinese, English, Japanese, Korean)

## Project Files

- `index.html`
  - Frontend app (UI, wallet connect, compression/encryption, upload flow, gallery)
- `on_chain_image.move`
  - Move smart contract (`Image`, `UploadSession`, start/append/finalize/cancel/delete)
- `Move.toml`
  - Move package config

## Features

### Wallets
- OKX wallet via dedicated provider (`window.okxwallet.sui`)
- Slush / Sui Wallet via `@mysten/wallet-standard`
- disconnect wallet button

### Upload Flow
- compress image in browser
- optional encrypt image before upload
- send transactions in sequence:
  1. `start_upload`
  2. `append_chunk` (multiple tx)
  3. `finalize_upload`
- on failure, app tries `cancel_upload` for cleanup

### Encryption
- optional password mode
- PBKDF2 key derivation + AES-256-GCM encryption on client
- only ciphertext + encryption metadata stored on chain
- no password recovery

### Image Management
- list owned images
- each image supports:
  - copy ID
  - download
  - owner delete
  - encrypted preview unlock
- lookup by Object ID (with optional password)

### UX
- no popup dialogs (`alert/confirm/prompt` removed)
- in-page log console for status/errors
- upload progress, compression info, and gas info shown in UI
- language switch with re-rendered historical log entries

## Smart Contract Summary (`on_chain_image.move`)

### Main structs
- `Image`
- `UploadSession`

### Main functions
- `start_upload(...) -> UploadSession`
- `append_chunk(&mut UploadSession, chunk)`
- `finalize_upload(UploadSession) -> Image`
- `cancel_upload(UploadSession)`
- `delete_image(Image)`
- `set_description(&mut Image, description)`

### Important limits
- `MAX_IMAGE_BYTES = 8_000_000`
- `MAX_CHUNK_BYTES = 16_000`
- uploader-only mutate/cancel/delete checks
- encryption metadata validation (salt/nonce/kdf rounds)

## Frontend Runtime Config (`index.html`)

Important current values:
- `TARGET_CHAIN = sui:mainnet`
- `CHUNK_SIZE_BYTES = 15800`
- `CHUNKS_PER_TX = 1`
- `KDF_ROUNDS = 250000`
- per-step gas budgets (start/append/finalize/cancel/delete)

Notes:
- Real gas cost is always determined by on-chain execution.
- UI values are estimates and accumulated results from tx effects.

## Run Locally

Use a local HTTP server (recommended instead of direct file open):

```bash
python -m http.server 8000
```

Then open:

`http://localhost:8000`

## Deploy Move Contract (example)

1. Install Sui CLI
2. Publish package:

```bash
sui client publish --gas-budget 100000000
```

3. Copy deployed `packageId`
4. In the web UI, set and apply the new `Package ID`

## Typical User Flow

1. Connect wallet
2. Confirm `Package ID`
3. Select image, set description, optional password
4. Upload
5. View in gallery or query by Object ID

## Troubleshooting

### "InsufficientGas" on append tx
- Often budget-per-tx issue, not total wallet balance issue
- This project already uses:
  - `CHUNKS_PER_TX = 1`
  - higher append gas budget

### "Input at index 0 is too large"
- A pure input exceeded size limit
- Reduce `CHUNK_SIZE_BYTES` and keep contract/frontend limits aligned

### Compression seems not reducing size
- Not necessarily a bug
- Already-optimized images may not shrink under near-lossless settings

### Forgot password
- Cannot be recovered
- Password is never stored on chain

## Open Source Checklist

Recommended to commit:
- `index.html`
- `on_chain_image.move`
- `Move.toml`
- `README.md`

Recommended to ignore temp files:
- `.tmp_*`

Suggested `.gitignore` rule:

```gitignore
.tmp_*
```

## Security Notes

- This project is a practical reference implementation.
- Before production use, add stronger testing/monitoring for:
  - large files and edge cases
  - retry/idempotency behavior
  - full error code mapping
- Even with password mode, ciphertext and metadata are public on chain.

## License

Add your preferred license (for example `MIT`).

