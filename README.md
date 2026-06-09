# Backend Scaffold Tool

> 基於 n8n 的後端專案自動化開框工具，填寫表單即可在本機產生完整的 NestJS / Express / .NET 後端專案結構。

---

## 目錄

- [功能特色](#-功能特色)
- [支援的技術棧](#-支援的技術棧)
- [專案結構](#-專案結構)
- [快速開始](#-快速開始)
- [環境變數設定](#-環境變數設定)
- [使用方式](#-使用方式)
- [產生的專案結構](#-產生的專案結構)
- [更新與維護](#-更新與維護)

---

## 功能特色

-  **表單驅動**：透過視覺化表單填寫需求，無需手動建立專案架構
-  **一鍵產生**：自動建立完整的後端專案資料夾，包含所有必要檔案
-  **技術棧彈性**：支援 TypeScript + NestJS / Express，以及 .NET Web API
-  **多資料庫支援**：MongoDB（native driver）、MSSQL / PostgreSQL / MySQL（Knex.js）
-  **多種驗證方式**：Joi、Zod、class-validator
-  **本機直接輸出**：產生的專案直接存放在指定的本機路徑
-  **可共用**：透過 Docker Compose + `.env` 設定，團隊成員下載即可使用

---

## 支援的技術棧

| 語言 + 框架 | 驗證方式 | 資料庫 |
|------------|---------|--------|
| TypeScript + NestJS | Joi / Zod / class-validator | MongoDB / MSSQL / PostgreSQL / MySQL |
| TypeScript + Express | Joi / Zod / class-validator | MongoDB / MSSQL / PostgreSQL / MySQL |
| .NET + Web API | FluentValidation / DataAnnotations | MSSQL / PostgreSQL / MySQL |

---

## 專案結構

```
backend-scaffold-tool/
├── docker-compose.yml        # n8n 啟動設定
├── .env.example              # 環境變數範本
├── .env                      # 本機環境變數（不納入版控）
├── workflows/
│   └── scaffold.json         # n8n workflow 匯出檔案
└── README.md
```

---

## 快速開始

### 前置需求

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Git

### 安裝步驟

**1. Clone 這個 repo**

```bash
git clone https://github.com/MengchunT/backend-scaffold-tool.git
cd backend-scaffold-tool
```

**2. 建立環境變數檔案**

```bash
cp .env.example .env
```

打開 `.env`，填入你的本機專案輸出路徑：

```env
# 產生的專案會存放在這個路徑下
PROJECTS_PATH=C:\Users\YourName\Projects
```

**3. 啟動 n8n**

```bash
docker-compose up -d
```

**4. 開啟 n8n 介面**

瀏覽器開啟 [http://localhost:5678](http://localhost:5678)，完成帳號設定。

**5. 匯入 workflow**

- 左側點 **Workflows** → 右上角點 **「+」** → 選 **「Import from file」**
- 選擇 `workflows/scaffold.json`

**6. 啟用 workflow**

進入 workflow 後，右上角把開關切換為 **Active**。

---

## 環境變數設定

複製 `.env.example` 為 `.env` 並填入以下設定：

```env
# 產生的後端專案存放路徑（必填）
PROJECTS_PATH=C:\Users\YourName\Projects
```

> `.env` 已加入 `.gitignore`，不會被推送到 GitHub，每個人在自己的電腦上設定即可。

---

## 使用方式

**1. 開啟表單**

啟動 n8n 後，進入 workflow，點擊 **Form Trigger** 節點，複製 **Test URL** 或 **Production URL** 在瀏覽器開啟。

**2. 填寫需求**

| 欄位 | 說明 |
|------|------|
| 專案名稱 | 資料夾名稱，建議使用 kebab-case（例如：`user-management-api`）|
| 專案描述 | 簡短描述專案用途 |
| 產生類型 | `backend`（後端代碼）/ `typespec`（API 規格）/ `both` |
| 語言、框架、驗證方式 | 從下拉選單選擇組合 |
| 資料庫 | mongodb / mssql / postgresql / mysql |

**3. 送出表單**

按下 Submit 後，workflow 會自動：
1. 解析技術棧
2. 產生所有專案檔案
3. 將檔案寫入 `PROJECTS_PATH/專案名稱/` 資料夾

**4. 開始開發**

```bash
cd $PROJECTS_PATH/your-project-name
cp .env.example .env   # 填入資料庫連線資訊
npm install
npm run start          # 自動編譯並啟動
```

---

## 產生的專案結構

以 **TypeScript + NestJS + MongoDB** 為例：

```
your-project/
├── src/
│   ├── api/
│   │   ├── auth/
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.schema.ts        ← 依驗證方式產生
│   │   │   └── strategies/
│   │   │       └── jwt.strategy.ts
│   │   └── users/
│   │       ├── users.controller.ts
│   │       ├── users.service.ts
│   │       └── users.module.ts
│   ├── common/
│   │   ├── decorators/               ← CurrentUser, Roles
│   │   ├── guards/                   ← JwtAuthGuard, RolesGuard
│   │   ├── interceptors/             ← ResponseInterceptor
│   │   └── pipes/                    ← ValidationPipe
│   ├── filters/
│   │   └── http-exception.filter.ts
│   ├── helpers/                      ← 共用工具函數
│   │   ├── auth.helper.ts
│   │   ├── common.helper.ts
│   │   ├── paging.helper.ts
│   │   ├── random.helper.ts
│   │   ├── regex.helper.ts
│   │   ├── string.helper.ts
│   │   └── util.helper.ts
│   ├── models/
│   │   ├── entities/                 ← User entity
│   │   ├── enums/                    ← UserRole, Status
│   │   └── shared/                   ← base, api, pagination, response
│   ├── schema/
│   │   └── base.schema.ts            ← 僅 Joi 時產生
│   ├── services/                     ← 僅 MongoDB 時產生
│   │   ├── db-client.service.ts
│   │   ├── db-query.service.ts
│   │   ├── common.service.ts
│   │   └── timezone.service.ts
│   ├── app.module.ts
│   └── main.ts
├── .env.example
├── .gitignore
├── nest-cli.json
├── package.json
├── tsconfig.json
├── tsconfig.build.json
└── README.md
```

---

## 更新與維護

當 workflow 有更新時：

**匯出最新版本**

在 n8n 畫布右上角點 **`...`** → **「Export」** → 下載 `.json`

將下載的檔案覆蓋 `workflows/scaffold.json` 後推到 GitHub：

```bash
git add workflows/scaffold.json
git commit -m "chore: update scaffold workflow"
git push
```

**其他人更新**

```bash
git pull
```

然後在 n8n 重新 Import `workflows/scaffold.json` 即可。

---

## 貢獻

歡迎提交 Issue 或 PR 來改善這個工具，常見的改善方向：

- 新增技術棧支援（例如 Fastify、Hono）
- 新增更多 helper 函數
- 改善產生的專案模板品質

---

*此工具使用 [n8n](https://n8n.io) 建立，在本機 Docker 環境中運行。*
