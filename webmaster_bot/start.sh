#!/bin/bash

echo "🤖 Starting Yandex Webmaster Bot..."

# Проверка виртуального окружения
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run: python -m venv venv"
    exit 1
fi

# Активация виртуального окружения
source venv/bin/activate

# Проверка .env
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please copy .env.example to .env and configure it"
    exit 1
fi

# Запуск бота
python bot.py
