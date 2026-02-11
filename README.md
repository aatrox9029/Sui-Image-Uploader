<p align="center">
  <img src="./icon.png" width="200" alt="Sui Image Uploader Icon">
</p>
 🌟 Main Features

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
---

## ⚖️ Disclaimer / 免責聲明

>  **Disclaimer of Liability:**
> 1. This project is provided strictly for technical research and demonstration purposes. The developer assumes no legal responsibility for any content uploaded by users.
> 2. Users are solely responsible for the data they upload (including images, text, or encrypted files). Uploading illegal, copyrighted, pornographic, violent, or harmful content is strictly prohibited.
> 3. Due to the immutable nature of blockchain technology, data uploaded to the Sui network may exist permanently. The developer has no control over, nor the ability to delete, data once it is finalized on the blockchain.
> 4. By using this tool, you acknowledge and agree that the developer is not liable for any legal disputes or regulatory violations arising from your use of the service. The tool is provided "as is" without any warranties.

> **重要聲明：**
> 1. 本專案僅作為技術研究與區塊鏈工具展示之用，開發者不對使用者上傳的任何內容承擔法律責任。
> 2. 使用者須對其上傳之所有數據（包括但不限於圖片、文字、加密檔案）負全部法律責任。嚴禁上傳任何違反法律、侵犯版權、色情、暴力或有害之內容。
> 3. 由於區塊鏈「不可篡改」之特性，上傳後的數據可能永久存在。開發者無法控制或刪除已存儲於 Sui 區塊鏈上的數據。
> 4. 使用本工具即表示您同意：任何法律糾紛或違規行為均與開發者無關，開發者不提供任何形式的擔保或補償。
