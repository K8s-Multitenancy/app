Bagus banget idenya! Untuk membuat semacam **navigasi** dari judul-judul `#` dan subjudul `##`, `###`, dan seterusnya, kamu bisa menyusun **daftar isi (Table of Contents)** yang bisa langsung mengarahkan pembaca ke bagian tertentu hanya dengan mengklik tautannya — cocok banget kalau kamu masukkan di awal artikel Markdown seperti GitHub README atau dokumentasi pribadi.

Berikut contoh navigasi otomatis versi Markdown untuk struktur yang kamu punya:

---

## 🧭 Table of Contents

- [What Are We Going to Build?](#what-are-we-going-to-build)
- [What do I need to proceed?](#what-do-i-need-to-proceed)
- [System preparation](#system-preparation)
  - [Check the port availability](#check-the-port-availability)
  - [Disable Ubuntu Firewall](#disable-ubuntu-firewall--cp-w)
  - [Update and upgrade the system](#update-and-upgrade-the-system--cp-w)
  - [Enable time-sync with an NTP server](#enable-time-sync-with-an-ntp-server--cp-w)
  - [Turn off the swap](#turn-of-the-swap--cp-w)
  - [Configure required kernel modules](#configure-required-kernel-modules--cp-w)
  - [Configure network parameters](#configure-network-parameters--cp-w)
  - [Install necessary software tools to continue](#install-necessary-software-tools-to-continue--cp-w)
- [Install Kubernetes Tools & containerd Runtime](#install-kubernetes-tools--containerd-runtime)
  - [Install Kubernetes Tools](#install-kubernetes-tools)
    - [Add Kubernetes repository and keys](#add-kubernetes-repository-and-keys--cp-w)
  - [Install containerd runtime](#install-containerd-runtime)
    - [Configure containerd](#configure-containerd--cp-w)
    - [Setup crictl](#setup-crictl-for-inspecting-containers--cp-w)
- [Enable kubelet service](#enable-kubelet-service--cw-p)
- [Initializing Control-Plane Node](#initializing-control-plane-node)
  - [Pull necessary Kubernetes images](#pull-necessary-kubernets-images--cp)
  - [Initialize the control-plane](#initialize-the-control-plane--cp)
  - [Add network add-on](#add-network-add-on--cp)
- [Join the Worker Node to Kubernetes Control-Plane](#join-the-worker-node-to-kubernets-control-plane)
  - [Generate the join command](#switch-to-the-control-plane-node-and-generate-the-join-command--cp)
  - [Join from worker node](#switch-to-the-worker-node-and-follow-the-below-instructions--w)
  - [Verify on control-plane](#switch-back-to-the-control-plane-node-and-run-the-below-command-to-verify--cp)

---

💡 **Cara Pakai:**

- Pastikan ini ditempatkan setelah judul utama (biasanya setelah `# Step-by-Step Guide to Creating a Kubernetes Cluster on Ubuntu 22.04`)
- Markdown parser (seperti GitHub, GitLab, atau VS Code preview) akan otomatis menjadikan ini **link anchor** ke tiap bagian.

Kalau kamu ingin versi klik-able di HTML (untuk blog misalnya), aku bisa bantu ubah jadi versi HTML anchor juga. Mau sekalian?

## 🧭 Table of Contents

- [📌 What Are We Going to Build?](#what-are-we-going-to-build)
- [🧰 Requirements](#requirements)
- [🛠️ System Preparation](#system-preparation)
  - [🔎 Check the Port Availability](#check-the-port-availability)
  - [🛡️ Disable Firewall](#disable-ubuntu-firewall--cp-w)
  - [⬆️ System Update & Upgrade](#update-and-upgrade-the-system--cp-w)
  - [⏰ Time Sync with NTP](#enable-time-sync-with-an-ntp-server--cp-w)
  - [🚫 Turn Off Swap](#turn-of-the-swap--cp-w)
  - [🧮 Configure Kernel Modules](#configure-required-kernel-modules--cp-w)
  - [🌐 Network Parameters](#configure-network-parameters--cp-w)
  - [🧰 Install Basic Tools](#install-necessary-software-tools-to-continue--cp-w)
- [📦 Install Kubernetes Tools & containerd Runtime](#install-kubernetes-tools--containerd-runtime)
  - [📦 Add Kubernetes Repo](#add-kubernetes-repo-cp-w)
  - [🐳 Install containerd](#install-containerd-runtime)
  - [🔍 Setup crictl](#setup-crictl-cp-w)
- [🧩 Enable kubelet](#enable-kubelet-service-cp-w)
- [🎛️ Initializing Control Plane](#initializing-control-plane)
  - [⬇️ Pull Kubernetes Images](#pull-kubernetes-images-cp)
  - [🚀 kubeadm init](#kubeadm-init-cp)
  - [🌐 Apply CNI Plugin (Weave)](#-apply-cni-plugin-cp)
- [🤝 Join Worker Node to Cluster](#-join-worker-node-to-cluster)

  - [🔐 Generate Join Command](#-generate-join-command-cp)
  - [🔗 Execute Join on Worker](#-execute-join-on-worker-node-w)
  - [✅ Verify Node Join](#-verify-node-on-control-plane-cp)

  Tentu! Berikut adalah versi **Table of Contents** kamu yang sudah ditambahkan dengan **emoji yang pas** untuk mempermudah navigasi dan mempercantik tampilan Markdown-nya:

---

## 🧭 Table of Contents

- [📌 What Are We Going to Build?](#what-are-we-going-to-build)
- [🧰 Requirements](#requirements)
- [🛠️ System Preparation](#system-preparation)
  - [🔍 Check the Port Availability](#check-the-port-availability)
  - [🧱 Disable Ubuntu Firewall](#disable-ubuntu-firewall--cp-w)
  - [🔄 Update and Upgrade the System](#update-and-upgrade-the-system--cp-w)
  - [⏱️ Enable Time-Sync with an NTP Server](#enable-time-sync-with-an-ntp-server--cp-w)
  - [📉 Turn Off the Swap](#turn-of-the-swap--cp-w)
  - [🧩 Configure Required Kernel Modules](#configure-required-kernel-modules--cp-w)
  - [🌐 Configure Network Parameters](#configure-network-parameters--cp-w)
  - [🧰 Install Necessary Software Tools to Continue](#install-necessary-software-tools-to-continue--cp-w)
- [📦 Install Kubernetes Tools & containerd Runtime](#install-kubernetes-tools--containerd-runtime)
  - [🔧 Install Kubernetes Tools](#install-kubernetes-tools)
    - [🔐 Add Kubernetes Repository and Keys](#add-kubernetes-repository-and-keys--cp-w)
  - [📦 Install containerd Runtime](#install-containerd-runtime)
    - [⚙️ Configure containerd](#configure-containerd--cp-w)
    - [🔎 Setup crictl](#setup-crictl-for-inspecting-containers--cp-w)
- [🚀 Enable kubelet Service](#enable-kubelet-service--cw-p)
- [🌟 Initializing Control-Plane Node](#initializing-control-plane-node)
  - [📥 Pull Necessary Kubernetes Images](#pull-necessary-kubernets-images--cp)
  - [🧪 Initialize the Control-Plane](#initialize-the-control-plane--cp)
  - [🕸️ Add Network Add-on](#add-network-add-on--cp)
- [🔗 Join the Worker Node to Kubernetes Control-Plane](#join-the-worker-node-to-kubernets-control-plane)
  - [🛠️ Generate the Join Command](#switch-to-the-control-plane-node-and-generate-the-join-command--cp)
  - [💻 Join from Worker Node](#switch-to-the-worker-node-and-follow-the-below-instructions--w)
  - [🔎 Verify on Control-Plane](#switch-back-to-the-control-plane-node-and-run-the-below-command-to-verify--cp)

---

Kalau kamu ingin sekaligus **auto-generate anchor link dari heading file secara otomatis**, kamu bisa pakai VS Code plugin seperti **Markdown All in One**, atau pakai GitHub native ToC dari klik tombol “...” di atas file > “Table of contents”.

Mau lanjut aku bantuin format isi dokumen markdown kamu jadi clean seperti ini juga?
