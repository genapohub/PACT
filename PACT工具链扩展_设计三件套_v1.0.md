# PACT 工具链扩展：AI 设计三件套接入方案 v1.0

> 配套 `PACT：产品 AI 契约化交付流程` 使用。
> 本方案解决 PACT 有意留白、但实际执行会卡住的三个问题：
> **视觉规范的具体值从哪来、Mock 原型用什么生成、组件素材从哪找。**
>
> 三件套 = DESIGN.md 素材库（vibeui.top / awesome-design-md）· Open Design · UI Verse
> 编制日期：2026-09-26

---

## 0. 一句话结论

PACT 定好了流程骨架和契约载体（Markdown 文件），但没规定「页面设计契约里的 Design Token 具体值从哪来」「可交互原型拿什么做」「组件素材去哪找」。这三件事，正好由三个工具一一补上，而且它们**和 PACT 同源**——都是「纯文件产出、本地优先、不入云、产物可追溯到契约」。

关键判断：

> **DESIGN.md 是唯一的桥梁。** 它同时是 PACT 的视觉契约、Open Design 的输入、coding agent 的规范。先把 DESIGN.md 立起来，另外两个工具才有意义。

**不要三个一起上。** 按 `DESIGN.md → Open Design → UI Verse` 的顺序按需引入，见第 9 节。

---

## 1. 三件套在 PACT 六阶段的落位

| PACT 阶段 | 原有产出 | 三件套补什么 | 用什么工具 |
|---|---|---|---|
| Phase 1 需求结构化 | PRD、页面清单、验收清单 | 不介入 | — |
| **Phase 2 页面设计契约** | 页面设计契约、design-tokens.json、组件规范 | **Design Token / 视觉规范的具体来源** | **DESIGN.md** + UI Verse |
| Phase 3 API 接口契约 | API 契约、openapi.yaml | 不介入（接口与视觉无关） | — |
| **Phase 4 前端 Mock 原型** | `06-项目编码/frontend/` | **快速产出高保真可交互原型** | **Open Design** + DESIGN.md |
| Phase 5 后端 API 实现 | `06-项目编码/backend/` | 不介入 | — |
| **Phase 6 联调与验收** | 联调记录、UIUX 走查报告 | **走查时对齐的设计基准** | DESIGN.md（作走查依据） |

```text
PRD ─→ 页面设计契约 ─→ API 契约 ─→ 前端 Mock ─→ 后端 API ─→ 联调验收
          ▲  ▲                        ▲                         ▲
     DESIGN.md │                   Open Design              DESIGN.md
          UI Verse                   (+ DESIGN.md)          （走查基准）
```

阶段门禁新增一条（接 PACT 5.5）：

| 阶段 | 新增门禁 |
|---|---|
| PRD → 页面设计契约 | 项目根目录已存在 `DESIGN.md`，且页面设计契约里的 Token 全部来自它 |

---

## 2. 核心机制：DESIGN.md 是 PACT 的「视觉契约层」

### 2.1 它是什么

一份**纯 Markdown** 的视觉设计系统文档，共 9 个模块：视觉主题、色板与语义命名、字体规则、组件样式、布局原则、阴影层级、Do's and Don'ts、响应式行为、Agent Prompt Guide。

它源自 Google Stitch 的「Vibe Design」概念，被 `VoltAgent/awesome-design-md`（GitHub，MIT，8 万+ star）做成了可复用的素材库，`vibeui.top` 是它的可视化索引站（112 个品牌模板）。

### 2.2 为什么它能当桥梁

因为它同时满足两个条件：**AI 读得懂 + 三方能共用**。

| 谁消费 | 怎么用 |
|---|---|
| 你的 coding agent（Claude Code / Codex / Cursor / Trae） | 读它生成页面，颜色字号间距不跑偏 |
| Open Design | 把它作为 design system，生成原型时自动带入色板/字体/间距 |
| PACT 的页面设计契约 | 作为 Design Token 和组件规范的**源头** |

> Open Design 官方文档原话：**"your team's DESIGN.md becomes the brand contract"**——它把 DESIGN.md 直接当作品牌契约，和 PACT 的契约理念完全一致。这就是两者能焊接的根本原因。

### 2.3 与 PACT 既有产物的派生关系

DESIGN.md 不是新增一个「平行文档」，而是**上游源头**，PACT 原有的产物从它派生：

```text
DESIGN.md（视觉契约，1 份）
├── → 04-UIUX设计/design-tokens.json     把第 2/3/5 节转成 JSON token
├── → 04-UIUX设计/组件规范_v1.0.md        把第 4 节展开成组件清单与状态
├── → 04-UIUX设计/页面设计契约_v1.0.md    契约里的视觉描述引用 Token 名
├── → 06-项目编码/miniapp/app.wxss       把第 2/3 节转成 CSS 变量 + rpx
└── → 被 Open Design 注册为 design system
```

**原则**：改视觉先改 DESIGN.md，再同步派生产物——和 PACT「代码变更必须追溯到契约变更」同一条纪律。

---

## 3. Phase 2 实操：用 DESIGN.md 补齐页面设计契约

### 3.1 三个来源，按成本从低到高

| 来源 | 适用 | 做法 |
|---|---|---|
| 抄现成的 | 想模仿某个成熟产品的风格 | 从 `awesome-design-md`（或 vibeui.top 索引）挑一个最接近的，改色值 |
| 自写 | 有明确品牌规范 | 复制 `templates/DESIGN.md模板.md`，填 `[方括号]` |
| 反向提取 | 已有设计稿/截图/Figma | 丢进 Open Design，让它提取成 DESIGN.md |

> 注：`awesome-design-md` 里的文件是「灵感参考」，模仿他人品牌做**对外产品**涉及商标风险，落地时务必换成自己的色值。

### 3.2 落地步骤

```text
1. 项目根目录放入 DESIGN.md
2. 告诉 AI：
   请读取 DESIGN.md 和 02-产品文档/xxx_PRD_v1.0.md，
   生成 04-UIUX设计/xxx_页面设计契约_v1.0.md 和 04-UIUX设计/design-tokens.json。
   页面设计契约里的颜色、字号、间距、圆角全部引用 DESIGN.md 的语义 Token 名，不要写死数值。
3. 人工 Review：Token 命名是否语义化、是否漏了状态色
```

### 3.3 提示词（接 PACT 8.1，追加一段视觉约束）

```text
视觉规范补充要求：
- 所有视觉描述引用 DESIGN.md 的语义 Token（如 --color-primary），不写死 hex。
- 每个页面补齐 default / loading / empty / error / success / disabled 六态。
- 触控目标 ≥ 44px；危险操作必须二次确认。
- 不要生成营销页风格。
```

---

## 4. Phase 4 实操：用 Open Design 产出 Mock 原型

Open Design 是 PACT「Mock 前端原型」这一阶段的高效执行引擎——它把你已有的 coding agent 变成设计引擎，直接产出**可运行的原型文件**（HTML / PDF / PPTX / MP4）。

### 4.1 安装（macOS，张工 M2 用 arm64 版）

**桌面端（推荐，最省事）**

```text
下载地址：https://open-design.ai/  →  下载桌面端
或 GitHub Releases：
  Apple Silicon(M系列)：open-design-0.24.1-mac-arm64.dmg
  Intel：              open-design-0.24.1-mac-x64.dmg
```

**CLI 集成（可选，接进 Claude Code / Codex 等）**

```bash
# 安装后 Open Design 提供 od 命令，把 MCP 装进你的 agent
od mcp install claude      # Claude Code
od mcp install codex       # Codex CLI
```

前置：本机已有 Node 24+，且已装至少一个支持的 agent（Claude Code / Codex / Cursor / Gemini CLI / DeepSeek Harness 等 21 款）。

### 4.2 把 DESIGN.md 注册为设计系统

按官方工作流：

```text
1. 把项目根目录的 DESIGN.md 放进仓库的 design-systems/<你的品牌>/ 下
2. 在 Open Design 里选中这个 design system
3. 之后所有生成都自动带上你的色板/字体/间距，无需重复提示
```

也可以反向：把 Figma 导出或截图拖进 Open Design，让它**提取**成一份 DESIGN.md。

### 4.3 生成原型并归位到 PACT 目录

```text
选 artifact 类型：Prototype / Mobile app / Deck
选 design system：<你的品牌>
输入 brief：从 04-UIUX设计/页面设计契约 里取页面目标与信息架构
产出 → 落到 04-UIUX设计/prototype/（作为视觉基准）
    或 → 06-项目编码/frontend/（继续工程化）
```

**产物用途（两种，别混）**

| 产物 | 用途 | 归位 |
|---|---|---|
| HTML 原型 | 视觉基准 / 交互确认 | `04-UIUX设计/prototype/` |
| PPTX / PDF | 汇报、评审、对外 | `07-其他文档/` |

### 4.4 边界（重要）

- Open Design 产出的是 **HTML**，**不能直接当小程序代码**。它的价值是「视觉基准 + 交互确认」，小程序代码仍须由 agent 按 `页面设计契约 + DESIGN.md` 生成 WXML/WXSS。
- 它是 **BYOK**：产品免费，模型费用你自己付；没有厂商云，产物落在你的项目目录。
- 首次使用要给它一个「工作目录」，建议直接指向 PACT 项目根目录，让它读到契约文件。

---

## 5. 组件层实操：用 UI Verse 补素材

UI Verse（`uiverse.io`，GitHub `uiverse-io/galaxy`，MIT，1.3 万 star）是**社区手写的 CSS/Tailwind 组件库**，不是 AI 驱动。定位是「现成零件」，补 PACT Phase 2 的组件规范、Phase 4 的实现效率。

### 5.1 取用

```text
1. uiverse.io 按标签找组件（按钮/卡片/表单/开关/加载态…）
2. 点 Get Code，复制 HTML + CSS
3. 登记进 04-UIUX设计/组件规范_v1.0.md：组件名 | 来源链接 | 已适配 Token | 状态
```

### 5.2 转成小程序 WXSS 的改写清单

UI Verse 组件是给浏览器的，直接贴进小程序会报错，按这张表改：

| 原（HTML/CSS） | 改成（WXML/WXSS） |
|---|---|
| `div` / `span` / `img` | `view` / `text` / `image` |
| `px` | `rpx`（×2，按 375px 设计稿基准） |
| 类名 + `:hover` | 小程序无 hover，改用 `hover-class` |
| 通配选择器 `*`、属性选择器 | 删除，改为显式类名 |
| `backdrop-filter`（毛玻璃） | 兼容性差，改用半透明纯色底 |
| CSS 变量 | 可用，但值必须来自 DESIGN.md Token |
| 外部字体 / 远程图标 | 不可用，改本地字体或 iconfont |

**规则**：UI Verse 只提供结构与交互灵感，**颜色一律替换成 DESIGN.md 的 Token**，否则会破坏视觉一致性。

---

## 6. 微信小程序适配要点（宠宝树场景）

PACT 支持小程序场景，三件套落到小程序有几个硬约束：

1. **DESIGN.md → app.wxss**
   ```css
   /* 06-项目编码/miniapp/app.wxss */
   page {
     --c-primary: #3370FF;
     --c-primary-weak: #E8F0FF;
     --c-danger: #F54A45;
     --c-text: #1F2329;
     --c-border: #DEE0E3;
     --c-fill: #F5F6F7;
   }
   ```
   小程序**支持 CSS 变量**，这是 DESIGN.md 落地小程序的关键通路。

2. **单位**：全部用 `rpx`。设计稿按 375px 宽 → `1px = 2rpx`。触控目标 ≥ `88rpx`。

3. **不支持的特性**：`*` 通配选择器、部分属性选择器、`position: fixed` 的部分场景、`backdrop-filter`（毛玻璃）需降级。DESIGN.md 里若写了玻璃拟态，小程序侧要删掉。

4. **图标**：UI Verse 常配 SVG/emoji 图标，小程序里统一改用 iconfont 或本地图标，**不用 emoji 当功能图标**（DESIGN.md 第 7 节已列为 Don't）。

5. **五态**：小程序要显式实现 loading（骨架屏）、empty（空状态引导）、error（可重试）、success、disabled——PACT 门禁要求。

---

## 7. 宠宝树实战：飞书风格 UI 改造端到端

以宠宝树「飞书风格改造（仅换肤）」为例走一遍：

```text
① Phase 2 视觉契约
   项目根目录放 DESIGN.md（用 templates/DESIGN.md模板.md，示例值就是飞书风蓝紫主色）
   → 让 AI 读 DESIGN.md + 宠宝树 PRD
   → 产出 04-UIUX设计/design-tokens.json + 页面设计契约

② 小程序铺底
   把 DESIGN.md 第 2/3 节转成 06-项目编码/miniapp/app.wxss 的 CSS 变量
   → 改造前先跑一遍：换肤只动 app.wxss，不动业务逻辑

③ Phase 4 原型（可选，若需要先确认视觉）
   Open Design 选该 DESIGN.md 为 design system
   → 生成关键页 Prototype（如订单详情、宠舍列表）
   → 产物放 04-UIUX设计/prototype/ 作为视觉基准

④ 组件补齐
   UI Verse 取飞书风格的卡片/表单/标签，按第 5.2 表转 WXSS，
   颜色替换成 DESIGN.md Token，登记进组件规范

⑤ Phase 6 走查
   拿 DESIGN.md 作基准做 UIUX 走查（PACT 7.2 那几条逐项过）
```

**这个项目的收益点**：飞书风格的核心是「克制的蓝紫 + 明确层级 + 统一圆角」，正好是 DESIGN.md 最擅长的部分。改造只碰 `app.wxss` 和组件样式，风险最低。

---

## 8. 组合工作流全景

```text
                    DESIGN.md（视觉契约 · 单一事实来源）
                          │
        ┌─────────────────┼──────────────────┐
        ▼                 ▼                  ▼
  页面设计契约        Open Design         coding agent
  + design-tokens     注册为 design      直接读它写代码
  + 组件规范          system
        │                 │
        │                 ▼
        │            高保真原型（HTML）
        │                 │
        ▼                 ▼
   API 契约 ────→ 前端 Mock / 工程化 ──→ 后端 API ──→ 联调验收
                          ▲
                    UI Verse 组件（转 WXSS，颜色换 Token）
```

一句话：**DESIGN.md 管"长什么样"，Open Design 管"快速看到"，UI Verse 管"少写点"，PACT 管"别跑偏"。**

---

## 9. 落地建议、坑与边界

### 9.1 最小起步路径（别一步到位）

| 步骤 | 做什么 | 成本 | 何时做 |
|---|---|---|---|
| 第 1 步（必做） | 项目根目录立一份 DESIGN.md | 30 分钟 | 立刻 |
| 第 2 步（高性价比） | 转出 app.wxss Token + 组件规范 | 1 小时 | 立刻 |
| 第 3 步（看需要） | 装 Open Design，做关键页原型 | 半天 | 需要先确认视觉时 |
| 第 4 步（随时） | UI Verse 按需取组件 | 按次 | 写具体组件时 |

先做第 1、2 步就能显著改善 AI 生成 UI 的一致性——**不用等工具链配齐**。

### 9.2 常见坑

1. **DESIGN.md 写成宣传文案**——它是给 AI 的规格，要写具体值（`#3370FF`、`圆角 6px`），不写"高级感""有质感"。
2. **Token 名不语义化**——写 `--color-blue` 早晚崩，写 `--color-primary`。
3. **Open Design 产出直接塞进小程序**——不行，HTML ≠ WXML，只作基准。
4. **UI Verse 组件带自己的颜色**——不换成 Token 就是视觉污染。
5. **只改代码不改 DESIGN.md**——违反 PACT「变更可追溯」，下次生成又跑偏。
6. **照抄大牌 DESIGN.md 对外发布**——商标风险，只作灵感。

### 9.3 明确不做的事

- 不把三件套当成「替代设计师」——DESIGN.md 描述的是规范，不是创意。
- 不为了用工具而用工具：接口契约阶段（Phase 3）跟视觉无关，不硬塞。
- 不引入第二个视觉源：全项目**只认一份 DESIGN.md**，避免多套 Token 打架。
- 不追求一次写全 DESIGN.md：先覆盖主色/字号/间距/圆角/按钮，再补组件细节。

---

## 附录：工具速查

| 工具 | 定位 | 仓库 / 站点 | 许可证 | 在 PACT 里 |
|---|---|---|---|---|
| DESIGN.md 素材 | 现成视觉规范库 | github.com/VoltAgent/awesome-design-md · vibeui.top | MIT | Phase 2 源头 |
| Open Design | Agent 驱动的设计引擎（桌面端 v0.24.1） | github.com/nexu-io/open-design · open-design.ai | Apache-2.0 | Phase 4 原型 |
| UI Verse | 社区 CSS/Tailwind 组件库 | uiverse.io · github.com/uiverse-io/galaxy | MIT | Phase 2/4 组件 |

配套文件：`templates/DESIGN.md模板.md`（可直接复制使用）
