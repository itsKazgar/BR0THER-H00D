#!/bin/bash
# ╔══════════════════════════════════════════════╗
# ║     BR0THER-H00D — ONE CLICK INSTALL        ║
# ╚══════════════════════════════════════════════╝

CY='\033[96m'; GR='\033[92m'; YL='\033[93m'; RD='\033[91m'; BD='\033[1m'; RS='\033[0m'

echo -e "${CY}${BD}"
echo "██████╗ ██████╗  ██████╗ ████████╗██╗  ██╗███████╗██████╗       ██╗  ██╗ ██████╗  ██████╗ ██████╗"
echo "██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗      ██║  ██║██╔═████╗██╔═████╗██╔══██╗"
echo "██████╔╝██████╔╝██║   ██║   ██║   ███████║█████╗  ██████╔╝█████╗███████║██║██╔██║██║██╔██║██║  ██║"
echo "██╔══██╗██╔══██╗██║   ██║   ██║   ██╔══██║██╔══╝  ██╔══██╗╚════╝██╔══██║████╔╝██║████╔╝██║██║  ██║"
echo "██████╔╝██║  ██║╚██████╔╝   ██║   ██║  ██║███████╗██║  ██║      ██║  ██║╚██████╔╝╚██████╔╝██████╔╝"
echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝"
echo -e "${RS}"
echo -e "${BD}Solana Alpha Collective — Install Script${RS}"
echo ""

# ── Python check ──────────────────────────────
if ! command -v python3 &>/dev/null; then
    echo -e "${RD}Python3 not found. Install it first: sudo apt install python3 python3-pip python3-venv${RS}"
    exit 1
fi
echo -e "${GR}✅ Python3 found: $(python3 --version)${RS}"

# ── Venv ──────────────────────────────────────
if [ ! -d "venv" ]; then
    echo -e "${YL}Creating virtual environment...${RS}"
    python3 -m venv venv
fi
source venv/bin/activate
echo -e "${GR}✅ Virtual environment ready${RS}"

# ── Dependencies ──────────────────────────────
echo -e "${YL}Installing dependencies...${RS}"
pip install -q --upgrade pip
pip install -q requests python-dotenv feedparser beautifulsoup4 psutil solders base58 python-telegram-bot httpx
echo -e "${GR}✅ Dependencies installed${RS}"

# ── .env setup ────────────────────────────────
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GR}✅ Created .env from template${RS}"
else
    echo -e "${GR}✅ .env already exists${RS}"
fi

# ── RAM check for Hermes ──────────────────────
FREE_RAM=$(free -m | awk '/^Mem:/{print $7}')
echo ""
echo -e "${BD}System check:${RS}"
echo -e "  RAM available: ${FREE_RAM}MB"
if [ "$FREE_RAM" -gt 8000 ]; then
    echo -e "  ${GR}✅ 8GB+ RAM — Hermes AI eligible (see SETUP_HERMES.md)${RS}"
elif [ "$FREE_RAM" -gt 3000 ]; then
    echo -e "  ${YL}⚠️  3-8GB RAM — Groq API recommended (free at console.groq.com)${RS}"
else
    echo -e "  ${YL}⚠️  Low RAM — rule-based mode (still works great)${RS}"
fi
# ── API Keys ──────────────────────────────────
echo ""
echo -e "${BD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RS}"
echo -e "${BD}  Step 1 — AI Brain (free at console.groq.com)  ${RS}"
echo -e "${BD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RS}"
read -p "  Groq API Key (press Enter to skip): " GROQ_KEY
if [ -n "$GROQ_KEY" ]; then
    sed -i "s|^GROQ_API_KEY=.*|GROQ_API_KEY=$GROQ_KEY|" .env
    echo -e "  ${GR}✅ Groq key saved${RS}"
fi

echo ""
echo -e "${BD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RS}"
echo -e "${BD}  Step 2 — Telegram (get token from @BotFather) ${RS}"
echo -e "${BD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RS}"
read -p "  Telegram Bot Token (press Enter to skip): " TG_TOKEN
if [ -n "$TG_TOKEN" ]; then
    sed -i "s|^TELEGRAM_BOT_TOKEN=.*|TELEGRAM_BOT_TOKEN=$TG_TOKEN|" .env
    echo -e "  ${GR}✅ Telegram token saved${RS}"
fi
read -p "  Telegram Chat ID (press Enter to skip): " TG_CHAT
if [ -n "$TG_CHAT" ]; then
    sed -i "s|^TELEGRAM_CHAT_ID=.*|TELEGRAM_CHAT_ID=$TG_CHAT|" .env
    echo -e "  ${GR}✅ Telegram chat ID saved${RS}"
fi

echo ""
echo -e "${BD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RS}"
echo -e "${BD}  Step 3 — Solana Wallet                        ${RS}"
echo -e "${BD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RS}"
echo "  [1] Create a new wallet"
echo "  [2] Import existing private key"
echo "  [3] Skip — paper trading only"
read -p "  Choice (1/2/3): " WALLET_CHOICE

if [ "$WALLET_CHOICE" = "1" ]; then
    echo -e "  ${YL}Generating new Solana wallet...${RS}"
    WALLET_INFO=$(python3 - << 'PYEOF'
from solders.keypair import Keypair
import base58
kp = Keypair()
pk = base58.b58encode(bytes(kp)).decode()
print(f"{kp.pubkey()}|{pk}")
PYEOF
)
    WALLET_ADDRESS=$(echo $WALLET_INFO | cut -d'|' -f1)
    WALLET_PRIVATE=$(echo $WALLET_INFO | cut -d'|' -f2)
    sed -i "s|^WALLET_ADDRESS=.*|WALLET_ADDRESS=$WALLET_ADDRESS|" .env
    sed -i "s|^WALLET_PRIVATE_KEY=.*|WALLET_PRIVATE_KEY=$WALLET_PRIVATE|" .env
    echo ""
    echo -e "  ${GR}✅ New wallet created!${RS}"
    echo -e "  ${BD}Address:${RS} $WALLET_ADDRESS"
    echo -e "  ${BD}Private Key:${RS} $WALLET_PRIVATE"
    echo -e "  ${RD}⚠️  Save your private key somewhere safe — this is the only time it's shown!${RS}"

elif [ "$WALLET_CHOICE" = "2" ]; then
    read -p "  Paste your private key: " IMPORT_KEY
    if [ -n "$IMPORT_KEY" ]; then
        WALLET_ADDRESS=$(python3 - << PYEOF
from solders.keypair import Keypair
import base58
try:
    kp = Keypair.from_bytes(base58.b58decode("$IMPORT_KEY"))
    print(kp.pubkey())
except:
    print("invalid")
PYEOF
)
        if [ "$WALLET_ADDRESS" = "invalid" ]; then
            echo -e "  ${RD}❌ Invalid private key${RS}"
        else
            sed -i "s|^WALLET_ADDRESS=.*|WALLET_ADDRESS=$WALLET_ADDRESS|" .env
            sed -i "s|^WALLET_PRIVATE_KEY=.*|WALLET_PRIVATE_KEY=$IMPORT_KEY|" .env
            echo -e "  ${GR}✅ Wallet imported: $WALLET_ADDRESS${RS}"
        fi
    fi
else
    echo -e "  ${YL}Skipped — paper trading mode${RS}"
fi

# ── Done ──────────────────────────────────────
echo ""
echo -e "${CY}${BD}╔══════════════════════════════════════════════╗${RS}"
echo -e "${CY}${BD}║   ✅ INSTALL COMPLETE                        ║${RS}"
echo -e "${CY}${BD}╠══════════════════════════════════════════════╣${RS}"
echo -e "${CY}${BD}║   Run now:  python Start.py                  ║${RS}"
echo -e "${CY}${BD}║   Tier 0:   works immediately, no keys       ║${RS}"
echo -e "${CY}${BD}║   Tier 1:   add keys to .env for smarter AI  ║${RS}"
echo -e "${CY}${BD}║   Tier 2:   add wallet to .env to go live    ║${RS}"
echo -e "${CY}${BD}╚══════════════════════════════════════════════╝${RS}"
echo ""
