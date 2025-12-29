# Template Index

Bu klasör, kişiselleştirilmiş agent sistemi kurmak için gereken template dosyalarını içerir.

## Template Kategorileri

### 📁 Memory Templates

Hafıza sistemi için dosya template'leri:

| Dosya | Açıklama | Kullanım |
|-------|----------|----------|
| `todo.md.template` | Aktif görevler ve hedefler | Günlük/haftalık güncellenir |
| `current_focus.md.template` | Mevcut öncelikler ve odak | Her session güncelenir |
| `learnings.md.template` | Birikmiş bilgi ve öğrenimler | Claude otomatik günceller |
| `preferences.md.template` | Kullanıcı tercihleri | İhtiyaç olduğunda güncellenir |
| `daily-log.md.template` | Günlük session özeti | Claude otomatik oluşturur |

**Kullanım:**
```bash
cp templates/memory/todo.md.template memory/state/todo.md
# Sonra kendi bilgilerinle doldur
```

---

### 🎯 Skills Templates

Özel yetenekler için template'ler:

| Dosya | Açıklama | Seviye |
|-------|----------|---------|
| `SKILL-TEMPLATE.md` | Genel skill template'i | Başlangıç |
| `research-skill-example.md` | Web araştırma skill örneği | Orta |
| `task-automation-example.md` | Task otomasyon skill örneği | Orta |

**Kullanım:**
```bash
# Yeni skill oluştur
mkdir -p .claude/skills/my-skill
cp templates/skills/SKILL-TEMPLATE.md .claude/skills/my-skill/SKILL.md
# SKILL.md'yi özelleştir
```

**Örneklerden Öğren:**
- `research-skill-example.md` → Exa + Firecrawl ile araştırma
- `task-automation-example.md` → Trello/Notion otomasyon

---

### ⚙️ Hooks Templates

Otomatik workflow'lar için hook scriptleri:

| Dosya | Açıklama | Gereksinim |
|-------|----------|-----------|
| `session-start.sh.template` | Session başlangıç hook'u | Temel |
| `session-stop.sh.template` | Session bitiş hook'u | Temel |
| `README-hooks.md` | Hook sistemi kılavuzu | Dokümantasyon |

**Kullanım:**
```bash
# Hook'ları kopyala
mkdir -p .claude/hooks
cp templates/hooks/session-start.sh.template .claude/hooks/session-start.sh
cp templates/hooks/session-stop.sh.template .claude/hooks/session-stop.sh

# Executable yap
chmod +x .claude/hooks/*.sh

# settings.json'a ekle (README-hooks.md'ye bak)
```

**Öğrenme:**
- `README-hooks.md` → Tam hook kılavuzu

---

### 📝 Claude Templates

Ana sistem dosyaları:

| Dosya | Açıklama | Öncelik |
|-------|----------|---------|
| `CLAUDE.md.template` | Ana talimat dosyası | **Zorunlu** |
| `memory-system.md.template` | Hafıza sistemi kılavuzu | Önerilen |
| `decision-protocol.md.template` | Karar verme protokolü | Önerilen |

**Kullanım:**
```bash
# Ana dosyayı oluştur
cp templates/claude/CLAUDE.md.template CLAUDE.md
# Kendi bilgilerinle özelleştir (isim, rol, tercihler)

# Docs'ları oluştur
mkdir -p .claude/docs
cp templates/claude/memory-system.md.template .claude/docs/memory-system.md
cp templates/claude/decision-protocol.md.template .claude/docs/decision-protocol.md
```

---

## Kullanım Senaryoları

### Minimal Setup (5 dakika)

Sadece temel dosyalar:

```bash
# 1. Ana talimat
cp templates/claude/CLAUDE.md.template CLAUDE.md

# 2. Memory state
mkdir -p memory/state
cp templates/memory/todo.md.template memory/state/todo.md
cp templates/memory/current_focus.md.template memory/state/current_focus.md

# 3. Özelleştir ve test et
```

### Standard Setup (15 dakika)

Tam özellikli sistem:

```bash
# 1. Claude core
cp templates/claude/CLAUDE.md.template CLAUDE.md
mkdir -p .claude/docs
cp templates/claude/*.md.template .claude/docs/

# 2. Memory structure
mkdir -p memory/{state,knowledge,projects,daily}
cp templates/memory/*.template memory/knowledge/
cp templates/memory/todo.md.template memory/state/
cp templates/memory/current_focus.md.template memory/state/

# 3. Skill (opsiyonel)
mkdir -p .claude/skills/research
cp templates/skills/research-skill-example.md .claude/skills/research/SKILL.md

# 4. Özelleştir
```

### Advanced Setup (30 dakika)

Hooks + Skills + Full Integration:

```bash
# Standard setup +

# 1. Hooks
mkdir -p .claude/hooks
cp templates/hooks/*.sh.template .claude/hooks/
chmod +x .claude/hooks/*.sh

# 2. Multiple skills
# Her skill için template kopyala ve özelleştir

# 3. settings.json konfigüre et
# 4. MCP entegrasyonları
```

---

## Template Özelleştirme Rehberi

### 1. Placeholders (Değiştirilmesi Gerekenler)

Template'lerde şu placeholders var:

- `[User Name]` → Senin adın
- `[Date]` → Bugünün tarihi
- `[Role]` → Rolün (PM, Developer, Designer, etc.)
- `[Tool 1]`, `[Tool 2]` → Kullandığın araçlar
- `[Primary function]` → Ana işlevler

### 2. Silme/Ekleme

Template'ler generic - gereksiz kısımları sil:
- Kullanmadığın araçlar
- İhtiyacın olmayan özellikler
- İlgili olmayan bölümler

### 3. Kendi Bölümlerini Ekle

Template'lere özel bölümler ekleyebilirsin:
- Özel workflow'lar
- Domain-specific bilgi
- Takım kuralları

---

## Yardım & Destek

### Template Seçimi

**Rolüne göre:**
- **PM** → task-automation skill + Trello entegrasyonu
- **Developer** → minimal setup, git workflow
- **Designer** → asset management, feedback collection
- **Content Creator** → research skill + content skill

**Teknik seviyeye göre:**
- **Beginner** → Minimal setup, hooks yok
- **Intermediate** → Standard setup, basic hooks
- **Advanced** → Full setup, custom skills

### Sık Sorulan Sorular

**S: Tüm template'leri kullanmalı mıyım?**
A: Hayır, ihtiyacın olanları seç. Minimal setup ile başla, zamanla ekle.

**S: Template'leri nasıl özelleştiririm?**
A: Kopyala, `[placeholders]` değiştir, gereksizleri sil, kendine özel ekle.

**S: Skill template mi yoksa örnek mi kullanmalıyım?**
A: Örneğe bak, mantığı anla, kendi skill'in için template'i kullan.

**S: Hook'lar zorunlu mu?**
A: Hayır, advanced özellik. Beginner'lar için optional.

---

## Sonraki Adımlar

1. ✅ Template'leri incele
2. ✅ Senaryona göre seç (minimal/standard/advanced)
3. ✅ Kopyala ve özelleştir
4. ✅ Claude Code ile test et
5. ✅ İhtiyaca göre genişlet

**Hazır mısın?** `SETUP-README.md` dosyasına dön ve setup'a başla!

---

Created: 2025-12-29
Based on: opAgent v1.0
