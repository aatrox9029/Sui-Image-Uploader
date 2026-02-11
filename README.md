# Sui Secure Chunked Image Uploader

## Main Features

- Sui wallet connection support
  - OKX Wallet (dedicated flow)
  - Slush / Sui Wallet (wallet-standard)
- Chunked on-chain image upload (start / append / finalize)
- Near-lossless client-side image compression
- Optional password-protected upload (AES-256-GCM + PBKDF2)
- Upload session cancellation for interrupted uploads (`cancel_upload`)
- Owned image gallery
- Image lookup by Object ID
- Encrypted image unlock preview
- Image download
- Image delete (owner only)
- Upload progress, compression info, and GAS estimate/accumulation display
- Multilingual UI (Traditional Chinese / Simplified Chinese / English / Japanese / Korean)
<img width="603" height="1208" alt="image" src="https://github.com/user-attachments/assets/223951e0-b30e-42a4-805a-d656b34f5776" />

Compared to Walrus, my fully on-chain method is significantly more expensive but guarantees permanent storage. 
Practical tests show that storing a 75KB image costs 0.79 SUI. However, the system supports deletion, allowing users to reclaim 0.57 SUI (approximately 70%) as a storage rebate.
