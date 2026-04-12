---
name: project-lifecycle
description: Claude Code'un projeyi baştan sona yönetmesini sağlayan 8 fazlı yaşam döngüsü orkestratörü. Kullanıcıyı Discovery → Planning → Design → Build → Test → Document → Ship → Maintain yolculuğunda yönlendirir, her fazda uygun agent'ları ve skill'leri çağırır.
trigger: when user wants to start a new project from scratch, or wants guidance through a full project lifecycle
---

# Project Lifecycle Orchestrator

## Amaç

Bu skill Claude Code'a bir projeyi **baştan sona** yönetme yetkisi verir. Kullanıcı "yeni proje başlat" veya "bu projeyi sıfırdan kurgulayalım" dediğinde otomatik tetiklenir.

## Ne Zaman Aktif?

- Kullanıcı `/start-project` komutunu çalıştırdığında
- Kullanıcı "yeni proje" veya "proje başlat" dediğinde
- Mevcut proje bağlamı yoksa ve kullanıcı planlama/mimari isteğinde bulunduğunda

## 8 Faz

1.Discovery, 2.Planning, 3.Design, 4.Build, 5.Test, 6.Document, 7.Ship, 8.Maintain

Her faz için:
1. Giriş kriterini kontrol et
2. Kullanıcıya fazın sorularını sor
3. Uygun agent'ları (bu faza özel atanmış) çağır
4. Skill'leri kullan, çıktı dosyalarını üret
5. Çıkış kriterini doğrula
6. `project-state.json`'ı güncelle
7. Sonraki faza geçmeyi kullanıcıya sor

## Uygulama

Detaylı faz-agent-skill haritası için `start-project.md` dosyasına bakın.

## State

Proje durumu `decisions/project-state.json` dosyasında tutulur. Bu dosya sayesinde oturum kesilse bile proje kaldığı yerden devam eder.

## Tetikleme Örnekleri

- "Bir SaaS projesi başlatmak istiyorum"
- "Yeni bir CLI uygulaması kuralım"
- "Bu projeyi baştan planlayalım"
- "/start-project"
- "Full stack web app yapacağız, nereden başlayalım?"
