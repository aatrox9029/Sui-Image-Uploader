<p align="center">
  <img src="./icon.png" width="200" alt="Sui Image Uploader Icon">
</p>
## 🌟 Main Features

### 🔐 Security & Privacy

* **Encrypted Uploads**: Optional password protection using **AES-256-GCM** with **PBKDF2** key derivation.
* **Secure Preview**: Integrated encrypted image unlock and preview functionality.

### ⚡ Advanced Upload Engine

* **Chunked On-Chain Storage**: Reliable "Start → Append → Finalize" workflow for handling larger image files.
* **Client-Side Compression**: Near-lossless image compression to optimize storage costs and performance.
* **Interrupt Management**: Support for `cancel_upload` to clean up sessions and reclaim resources.
* **Gas Intelligence**: Real-time GAS estimation and accumulation display.

### 💼 Wallet & Assets

* **Multi-Wallet Support**:
* **OKX Wallet**: Optimized dedicated transaction flow.
* **Slush / Sui Wallet**: Full compatibility with **Wallet-Standard**.


* **Asset Management**:
* Personal Image Gallery for owned assets.
* Direct lookup by **Object ID**.
* Secure image download and permanent deletion (Owner only).



### 🌍 Global Experience

* **Multilingual UI**: Native support for **English, Traditional Chinese, Simplified Chinese, Japanese, and Korean**.
* **Visual Feedback**: Real-time upload progress, compression ratios, and transaction status.

---

## 💡 Comparison: On-Chain vs. Walrus

Compared to decentralized storage protocols like **Walrus**, this fully on-chain method is significantly more expensive but guarantees maximum data persistence directly within Sui objects.

* **Cost Efficiency**: Practical tests show that storing a **75KB image** costs approximately **0.79 SUI**.
* **Storage Rebate**: The system supports object destruction (deletion), allowing users to reclaim **0.57 SUI** (approx. **70%** of the initial cost) via the Sui Storage Rebate mechanism.

---

## 🚀 How to Use

### 1. Run the Frontend

* Open `index.html` using **VS Code**.
* Start the **Live Server** extension to host the file locally (this ensures wallet providers like OKX or Slush can detect the site via `http://localhost`).
* Connect your **Slush** or **OKX Wallet** (Ensure you are on **Sui Mainnet**).

### 2. Custom Deployment (Optional)

If you wish to deploy your own smart contract:

1. Go to [BitsLab IDE](https://ide.bitslab.xyz/).
2. Deploy the `on_chain_image` Move module.
3. Copy your new **Package ID**.
4. Replace the `PACKAGE_ID` constant in `index.html` with your deployed ID.
<img width="603" height="1208" alt="image" src="https://github.com/user-attachments/assets/27dd6f5f-8c91-4337-9464-0e968acd5618" />
