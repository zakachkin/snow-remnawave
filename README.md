# ❄️ Snow Remnawave

> ⚠️ **ТРЕБУЕТСЯ SUBSTRACTION PATCH 7.0.5 VERSION**

Этот скрипт добавляет эффект падающего снега в **Remnawave**.
Просто запустите `snow.sh` — и снег появится в подписке.

---

## ✨ Возможности
- ❄️ Красивый анимированный снеговой эффект
- ⚙️ Простая установка
- 🔧 Лёгкое удаление
- 💡 Не требует изменений в коде Remnawave

---

## 📦 Установка

```bash
git clone https://github.com/zakachkin/snow-remnawave.git
cd snow-remnawave
chmod +x snow.sh
./snow.sh
```

После выполнения команда автоматически применит снежный эффект 🤍

---

## 🎥 Пример

<p align="left">
  <img src="https://raw.githubusercontent.com/zakachkin/snow-remnawave/main/demo.gif" alt="Demo" width="300">
</p>

---

## 🔄 Удаление эффекта / Возврат к стандартному виду

Если вы захотите отключить снег и вернуть стандартный интерфейс **Remnawave**, просто выполните:

```bash
docker compose down remnawave-subscription-page && docker compose up -d remnawave-subscription-page
```

---

## ❗ Примечания

- Скрипт предназначен для версии **Substraction Patch 7.0.5**
- Используйте только в не‑прод окружении, если не уверены ⚠️

---

## 🧑‍💻 Автор
**Zakachkin**
