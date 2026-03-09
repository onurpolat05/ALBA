<p align="center">
  <img src="assets/banner.png" alt="ALBA - Rutin odakli yapay zeka yardimciniz" width="100%">
</p>

<p align="center">
  <a href="README.md">English</a> | <b>Türkçe</b> | <a href="README.de.md">Deutsch</a>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://docs.anthropic.com/en/docs/claude-code"><img src="https://img.shields.io/badge/Claude%20Code-v2.1.71+-purple.svg" alt="Claude Code"></a>
  <a href="https://github.com/onurpolat05/ALBA/stargazers"><img src="https://img.shields.io/github/stars/onurpolat05/ALBA?style=social" alt="Stars"></a>
</p>

---

ALBA, Claude Code'u sizin onceliklerinizi hatırlayan, hatalarınızdan ogrenen ve is akisiniza uyum saglayan bir **kisisel yapay zeka ajanina** donusturur — ister gelistirici, ister PM, arastirmaci, kurucu veya icerik uretici olun.

**10 dakikalik interaktif kurulum. Sifir bagimlilik. Tamamen markdown.**

<p align="center">
  <img src="assets/demo.gif" alt="ALBA /setup demo" width="100%">
</p>

## Sorun

Her yeni Claude Code oturumu sifirdan baslar. Dunku onceliklerinizden haberi yoktur. Projeleriniz hakkinda bir baglam tasimazsiniz. Ayni hatalar tekrarlanir. Is akisinizi her seferinde yeniden anlatirsiniz.

## Cozum

```
you@machine:~/alba$ claude
> /setup
```

7 soruya cevap verin. ALBA; kalici hafiza, otomatik is akislari ve kendini gelistiren davranislarla — rolunuze ozel bir ajan sistemi kurar.

## Ne Elde Ediyorsunuz

```
your-agent/
├── CLAUDE.md                     # Ajan beyni (< 200 satir)
├── memory/
│   ├── state/                    # Oncelikler, gorevler (her oturumda guncellenir)
│   ├── knowledge/                # Ogrenimler, hatalar, tercihler (otomatik guncellenir)
│   ├── projects/                 # Proje bazli baglamlar
│   └── daily/                    # Oturum gunlukleri (otomatik olusturulur)
├── .claude/
│   ├── skills/                   # 9 yerlesik skill
│   ├── hooks/                    # 6 otomatik olay isleyici
│   ├── rules/                    # Davranis kurallari (otomatik yuklenir)
│   ├── docs/                     # Referans dokumanlari (lazy-load)
│   └── settings.json             # Hook yapilandirmasi
```

## Temel Ozellikler

### Kalici Hafiza
Oturumlar arasinda kaybolmayan uc katmanli dosya tabanli hafiza. Git ile takip edilir, insan tarafindan okunabilir, sifir bagimlilik.

```
/start              → onceki oturumun onceliklerini yukler
  ... calisma ...
/end                → ilerlemeyi kaydeder, ogrenimleri not eder
  ... ertesi gun ...
/start              → kaldigi yerden devam eder
```

### 9 Yerlesik Skill

| Skill | Amac |
|-------|------|
| `/start` | Oturumu baslat — baglami yukle, oncelikleri goster |
| `/end` | Oturumu bitir — durumu kaydet, gunluk olustur |
| `/status` | Hizli bakis — gorevler, engeller, son oturum |
| `/research` | Yapilandirilmis ciktiyla web arastirmasi (subagent olarak calisir) |
| `/weekly-review` | Haftalik performans degerlendirmesi ve gelecek hafta planlamasi |
| `/extend` | Istediginiz zaman yeni skill, hook veya kural ekleyin |
| `/reflect` | Oturumlar arasi oruntu analizi |
| `/create-skill` | Rehberli skill olusturma sihirbazi |
| `/setup` | Interaktif ilk kurulum |

### 6 Otomatik Hook

| Olay | Ne Olur |
|------|---------|
| Oturum basladiginda | Dashboard yuklenir, oncelikler gosterilir |
| Tehlikeli komut | Calistirilmadan engellenir |
| Bash hatasi | Oruntu tespiti icin otomatik kaydedilir |
| Oturum bitiyorken | Durumu kaydetmek icin hatirlatma yapilir |
| Prompt yazildiginda | Ilgili skill'ler onerilir |
| Context sikistirmada | Kritik bilgiler korunur |

### Kendini Gelistirme

ALBA calismanizdan ogrenirler:
- **Hatalar** cozumleriyle birlikte otomatik kaydedilir (ayni hata bir daha tekrarlanmaz)
- **Ogrenimler** yeniden kullanilabilir kaliplar olarak saklanir
- **Tercihler** ajani duzelttiginizde guncellenir
- **`/reflect`** oturumlar arasindaki oruntuleri analiz eder ve yeni kurallar onerir

### Progressive Disclosure

CLAUDE.md 200 satirin altinda kalir. Sistem dokumanlari yalnizca ihtiyac duyuldugunda lazy-load edilir — context pencerenizi verimli tutar.

---

## Hizli Baslangic

### Secenek 1: GitHub Template (Onerilen)

GitHub'da **"Use this template"** butonuna tiklayin, ardindan:

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git my-agent
cd my-agent
claude
```

### Secenek 2: Dogrudan Clone

```bash
git clone https://github.com/onurpolat05/ALBA.git my-agent
cd my-agent
rm -rf .git && git init
claude
```

### Sonra:

```
/setup
```

7 soruya cevap verin (~10 dakika). Kisisellestirilmis ajaniniz hazir.

---

## Gunluk Is Akisi

```
Sabah:
  /start                    # "Oncelikleriniz: 1. API deadline Cuma  2. PR #42 review"

Calisma sirasinda:
  "research multi-agent patterns"    # /research subagent olarak calisir
  "durumum ne?"                      # /status hizli bakis gosterir

Gun sonu:
  /end                      # Ilerlemeyi kaydeder, ogrenimleri not eder, gunluk olusturur

Cuma:
  /weekly-review            # Haftayi analiz eder, gelecek haftayi planlar

Her zaman:
  /extend                   # "Icerik olusturma skill'i istiyorum" → olusturur
  /loop 30m /status         # Periyodik hatirlatmalar (Claude Code v2.1.71+)
```

---

## Karsilastirma

| Ozellik | Ham Claude Code | Diger Starter'lar | ALBA |
|---------|----------------|-------------------|------|
| Oturumlar arasi hafiza | Yok | Kismi (sadece hafiza) | 3 katmanli (state/knowledge/projects) |
| Kurulum deneyimi | Manuel yapilandirma | Kopyala-yapistir | Interaktif sihirbaz (7 soru) |
| Rol destegi | Genel | Sadece gelistirici | Her rol (5 ornek dahil) |
| Kendini gelistirme | Hayir | Hayir | Otomatik hata + ogrenim yakalama |
| Hook'lar | Manuel kurulum | Bazi sablonlar | 6 hook, otomatik yapilandirilmis |
| Skill'ler | Yerlesik yok | Degisken | 9 yerlesik, genisletilebilir |
| Context verimliligi | N/A | N/A | Progressive disclosure (< 200 satir) |
| `/loop` destegi | N/A | N/A | Dokumante edilmis entegrasyon |

---

## Ornekler

Eksiksiz ve calisan kurulumlar icin `examples/` klasorune bakin:

| Rol | Odak |
|-----|------|
| **[Gelistirici](examples/developer/)** | Kod projeleri, git is akislari, arastirma |
| **[Proje Yoneticisi](examples/project-manager/)** | Sprint yonetimi, paydas guncellemeleri, takim koordinasyonu |
| **[Icerik Uretici](examples/content-creator/)** | Icerik takvimi, arastirma, coklu platform yayinlama |
| **[Arastirmaci](examples/researcher/)** | Literatur taramasi, kaynak yonetimi, atif takibi |
| **[Kurucu](examples/founder/)** | Coklu musteri yonetimi, gelir takibi, kisisel marka |

Her ornek; onceden doldurulmus dashboard'lar, ornek gunlukler ve calisan hook yapilandirmalari icerir.

---

## Mimari

### Skills 2.0

Skill'ler acik metadata iceren YAML frontmatter kullanir:

```yaml
---
name: research
description: Web research with structured output
context: fork          # subagent olarak calisir (ana context'i sismez)
allowed-tools: [Read, Write, WebSearch, WebFetch]
---
```

`context: fork` = agir isler subagent olarak calisir. `context: inline` = hizli isler ana konusmada calisir.

### Hafiza Sistemi

```
HOT  (her oturum)     →  memory/state/dashboard.md, todo.md
WARM (ogrenildiginde) →  memory/knowledge/learnings.md, errors.md, preferences.md
COLD (proje bazli)    →  memory/projects/[name]/context.md
LOGS (otomatik)       →  memory/daily/YYYY-MM-DD.md
```

### Hook Sistemi

Hook'lar, Claude Code olaylari tarafindan tetiklenen ve `.claude/settings.json` icinde yapilandirilan bash script'leridir. Otomatik calisirlar — manuel cagirma gerektirmez.

### Uyumluluk

- **Claude Code auto-memory**: cakisma olmadan birlikte calisir ([detaylar](.claude/docs/memory-compatibility.md))
- **`/loop` zamanlama**: oturum kapsamli periyodik gorevler ([detaylar](.claude/docs/loop-integration.md))
- **MCP sunuculari**: opsiyonel (Trello, Gmail, Calendar, Exa, Firecrawl) — ALBA bagimsiz calisir

---

## ALBA'yi Genisletme

Kurulumdan sonra istediginiz zaman ozellik ekleyin:

```
/extend
```

Ya da dogal bir sekilde isteyin:
- "E-posta taslagi icin bir skill istiyorum"
- "Oturum sonunda otomatik commit yapan bir hook ekle"
- "Kod inceleme standartlari icin bir kural olustur"
- "Trello board'umu bagla"

---

## Gereksinimler

- **Claude Code** v2.1.50+ ([Kurulum](https://docs.anthropic.com/en/docs/claude-code))
- **Git**

MCP sunuculari opsiyonel iyilestirmelerdir — ALBA tamamen bagimsiz calisir.

---

## Katki

Katkilarinizi bekliyoruz! [CONTRIBUTING.md](CONTRIBUTING.md) dosyasina goz atin.

**En degerli katkilar:**
- Yeni roller icin ornek kurulumlar
- Ozel skill sablonlari
- Hook tarifleri
- Entegrasyon kilavuzlari

---

## Lisans

MIT Lisansi — [LICENSE](LICENSE) dosyasina bakin

---

## Topluluk

- [GitHub Issues](https://github.com/onurpolat05/alba/issues) — Hata raporlari ve ozellik istekleri
- [GitHub Discussions](https://github.com/onurpolat05/alba/discussions) — Sorular ve fikirler

---

*ALBA — Tutarli. Bagimsiz. Surekli ogrenen.*

> Adini Abla kedisinden alir. *Alba*, Latince'de "safak" anlamina gelir — yapay zeka is akisiniz icin yeni bir baslangic.

## Star History

<a href="https://star-history.com/#onurpolat05/ALBA&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date" />
 </picture>
</a>
