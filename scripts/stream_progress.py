#!/usr/bin/env python3
"""
Pretty-print Claude Code `--output-format stream-json` events as live,
one-line progress updates for populate-applications.sh.

Reads NDJSON from stdin (already tee'd to the log), prints concise progress
to stdout. Defensive by design: unknown/garbled lines are ignored so a
format change can never break the run.
"""
import sys, json, time

START = time.time()

def elapsed():
    s = int(time.time() - START)
    return f"{s // 60:02d}:{s % 60:02d}"

def trunc(s, n=96):
    s = " ".join(str(s).split())
    return s if len(s) <= n else s[: n - 1] + "…"

def tool_detail(name, inp):
    if not isinstance(inp, dict):
        return ""
    for key in ("query", "file_path", "path", "command", "url", "pattern", "prompt"):
        if inp.get(key):
            return trunc(inp[key], 80)
    return ""

def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            ev = json.loads(line)
        except Exception:
            continue
        try:
            t = ev.get("type")
            if t == "system" and ev.get("subtype") == "init":
                model = ev.get("model") or "?"
                print(f"    [{elapsed()}] ▶ agent session started (model: {model})", flush=True)
            elif t == "assistant":
                for blk in (ev.get("message") or {}).get("content") or []:
                    bt = blk.get("type")
                    if bt == "tool_use":
                        name = blk.get("name", "tool")
                        detail = tool_detail(name, blk.get("input"))
                        line_out = f"    [{elapsed()}] → {name}"
                        if detail:
                            line_out += f": {detail}"
                        print(line_out, flush=True)
                    elif bt == "text":
                        txt = (blk.get("text") or "").strip()
                        if txt:
                            first = txt.splitlines()[0]
                            print(f"    [{elapsed()}] · {trunc(first, 110)}", flush=True)
            elif t == "result":
                bits = []
                sub = ev.get("subtype")
                bits.append(f"agent finished ({sub})" if sub else "agent finished")
                if ev.get("num_turns") is not None:
                    bits.append(f"{ev['num_turns']} turns")
                cost = ev.get("total_cost_usd")
                if isinstance(cost, (int, float)):
                    bits.append(f"~${cost:.2f}")
                print(f"    [{elapsed()}] ■ " + " · ".join(bits), flush=True)
                res = (ev.get("result") or "").strip()
                if res:
                    print(f"    [{elapsed()}] ■ {trunc(res.splitlines()[-1], 140)}", flush=True)
        except Exception:
            continue

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
