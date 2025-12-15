#!/bin/bash

echo "=========================================="
echo "Installing Yandex Webmaster Bot v3.0"
echo "=========================================="

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# Создание виртуального окружения
echo "📦 Creating virtual environment..."
python3 -m venv venv

# Активация
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Установка зависимостей
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Создание .env если не существует
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit .env file and add your tokens!"
fi

echo ""
echo "=========================================="
echo "✅ Installation completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env file and add your tokens"
echo "2. Run: ./start.sh"
echo ""
