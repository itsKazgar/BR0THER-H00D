# BR0THER-H00D — Solana Alpha Collective

8 AI agents hunting Solana memecoins 24/7.

## QUICK START

    git clone https://github.com/itsKazgar/BR0THER-H00D
    cd BR0THER-H00D
    bash install.sh
    python Start.py

Select [2] Paper + Agents. No keys or wallet needed to start.

## THE 8 AGENTS

    Scanner       — hunts trending tokens across DexScreener, CoinGecko, pump.fun
    Whale Tracker — watches smart wallet moves
    News Scout    — reads crypto news and market sentiment
    Pump Hunter   — finds early pump.fun gems before they explode
    Risk Manager  — blocks bad trades, protects your balance
    Analyst       — AI reasoning on every signal before buying
    Trader        — executes buys and sells, manages positions
    Memory Keeper — logs wins/losses so the bot keeps learning

Every trade needs 7+ weighted votes from the council. No single agent can force a trade.

## MODES

    [1] Solo Paper Trade  — auto trader, no agents
    [2] Paper + Agents    — full system, fake money  <- start here
    [3] Live Trading      — real funds, all agents
    [4] Custom Mode       — build your own agents

## SETUP

    python setup.py

Free AI: Groq (console.groq.com) or OpenRouter (openrouter.ai)
Paid AI: Anthropic, OpenAI, Cerebras

## LIVE TRADING

Run setup.py and pick your wallet option:

    [1] Generate a new wallet automatically
    [2] Import existing private key (Phantom etc)
    [3] Skip — paper trading only

Start with $10-20. Never share your private key.

## DASHBOARD

    Terminal 1: python Start.py
    Terminal 2: python brotha_api.py
    Browser:    http://localhost:8000

## MEMORY

Learns from every trade. Stored in core/brain.db. Persists across restarts.

## LICENSE

MIT — use it, fork it, build on it.
