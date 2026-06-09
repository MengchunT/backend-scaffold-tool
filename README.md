# Backend Scaffold Tool

基於 n8n 的後端專案自動化開框工具，填寫表單即可在本機產生完整的 NestJS、Express 或 .NET 後端專案結構，同時支援產生 TypeSpec API 定義。

---

## 功能特色

表單驅動，透過視覺化表單填寫需求，無需手動建立專案架構。

一鍵產生，自動建立完整的後端專案資料夾，包含所有必要檔案。

技術棧彈性，支援 TypeScript NestJS、TypeScript Express 以及 .NET Web API。

多資料庫支援，包含 MongoDB（native driver）、MSSQL、PostgreSQL 和 MySQL（Knex.js）。

多種驗證方式，包含 Joi、Zod 和 class-validator。

本機直接輸出，產生的專案直接存放在你指定的本機路徑。

快速啟動，點兩下 start.bat 即可啟動工具並自動開啟表單。

---

## 支援的技術棧

TypeScript + NestJS，驗證方式支援 Joi、Zod、class-validator，資料庫支援 MongoDB、MSSQL、PostgreSQL、MySQL。

TypeScript + Express，驗證方式支援 Joi、Zod、class-validator，資料庫支援 MongoDB、MSSQL、PostgreSQL、MySQL。

.NET + Web API，驗證方式支援 FluentValidation、DataAnnotations，資料庫支援 MSSQL、PostgreSQL、MySQL。

---

## 前置需求

Docker Desktop，用來運行 n8n，下載網址 https://www.docker.com/products/docker-desktop

Git，用來 clone 這個 repo，下載網址 https://git-scm.com

---

## 首次安裝步驟

Step 1：Clone 這個 repo

開啟終端機（PowerShell 或 CMD），執行以下指令：

    git clone https://github.com/MengchunT/backend-scaffold-tool.git
    cd backend-scaffold-tool

Step 2：建立環境變數檔案

    cp .env.example .env

用記事本或任意編輯器開啟 .env，填入你想要存放產生專案的路徑：

    PROJECTS_PATH=C:\Users\你的名字\Projects

這個路徑就是之後產生的後端專案會出現的地方，資料夾不存在的話請先建立。

Step 3：啟動 n8n

確認 Docker Desktop 已開啟，然後在 backend-scaffold-tool 資料夾裡點兩下 start.bat。

第一次執行會自動下載 n8n 映像檔，約 500MB，需要等待幾分鐘。n8n 準備好後瀏覽器會自動開啟表單。

Step 4：設定 n8n 帳號

第一次開啟 n8n 會要求建立帳號，填入 Email 和密碼後按 Next 完成設定。這組帳號只存在你的本機，不會上傳到任何地方。

Step 5：匯入 Workflow

進入 n8n 後，左側點 Workflows，右上角點加號，選擇 Import from file，選擇 workflows/scaffold.json，進入 workflow 後，右上角點 Publish 啟用。

---

## 日常使用

之後要產生新專案，步驟只有三步。

第一步，點兩下 start.bat 啟動工具，n8n 準備好後瀏覽器會自動開啟表單。

第二步，填寫表單後按 Submit，等幾秒後去 PROJECTS_PATH 資料夾找產生的專案。

第三步，進入專案資料夾開始開發：

    cd C:\Users\你的名字\Projects\你填的專案名稱
    cp .env.example .env
    npm install
    npm run start

填完表單確認專案產生完成後，回到 start.bat 視窗按任意鍵，n8n 會自動關閉。

---

## 表單欄位說明

專案名稱：產生的資料夾名稱，建議使用 kebab-case，例如 user-management-api。

專案描述：簡短說明專案用途。

產生類型：backend 產生後端代碼，typespec 產生 TypeSpec API 定義。

語言、框架、驗證方式：從下拉選單選擇組合，例如 TypeScript + NestJS + Joi。

資料庫：從 mongodb、mssql、postgresql、mysql 中選擇。

---

## 產生的後端專案結構

以 TypeScript + NestJS + Joi + MongoDB 為例：

    your-project/
    ├── src/
    │   ├── api/
    │   │   ├── auth/                     JWT 認證模組
    │   │   └── users/                    使用者模組
    │   ├── common/
    │   │   ├── decorators/               CurrentUser、Roles
    │   │   ├── guards/                   JwtAuthGuard、RolesGuard
    │   │   ├── interceptors/             統一回應格式
    │   │   └── pipes/                    驗證 Pipe
    │   ├── filters/
    │   │   └── http-exception.filter.ts  全域錯誤處理
    │   ├── helpers/                      共用工具函數
    │   ├── models/
    │   │   ├── entities/                 User
    │   │   ├── enums/                    UserRole、Status
    │   │   └── shared/                   base、api、pagination、response
    │   ├── schema/                       共用 Joi Schema（僅 Joi）
    │   ├── services/                     僅 MongoDB 時產生
    │   ├── app.module.ts
    │   └── main.ts
    ├── .env.example
    ├── package.json
    └── README.md

---

## 產生的 TypeSpec 專案結構

    your-project/
    ├── src/
    │   ├── models/
    │   │   ├── entities/                 User
    │   │   ├── enums/                    UserRole、Status
    │   │   ├── requests/                 Auth 請求
    │   │   ├── responses/                Auth 回應
    │   │   └── shared/                   base、pagination、response
    │   ├── routes/
    │   │   ├── auth.tsp                  認證 API
    │   │   └── users.tsp                 使用者 API
    │   ├── api.tsp                       Service 宣告
    │   └── main.tsp                      主入口
    ├── prisma/
    │   └── schema.prisma                 資料模型
    ├── tspconfig.yaml
    ├── package.json
    └── README.md

---

## 更新 Workflow

當工具有更新時，執行以下指令拉取最新版本：

    git pull

然後在 n8n 重新 Import workflows/scaffold.json，左側點 Workflows，找到現有的 scaffold workflow，右上角點三個點，選 Import from file，選新的 scaffold.json 覆蓋匯入。

---

## 常見問題

問：點 start.bat 後瀏覽器開啟但表單無法使用。
答：n8n 可能還在初始化，腳本會自動偵測並等待，最多 60 秒後才開啟瀏覽器。

問：產生的專案資料夾在哪裡找不到。
答：確認 .env 裡的 PROJECTS_PATH 路徑是否存在，路徑中不要有中文或特殊字元。

問：npm run start 跑不起來。
答：先複製 .env.example 為 .env 並填入資料庫連線資訊，再重新執行。

問：Workflow 啟用後表單還是出現錯誤。
答：確認 n8n 裡的 workflow 狀態是 Published，點 Publish 按鈕即可。

---

此工具使用 n8n 建立，在本機 Docker 環境中運行。
