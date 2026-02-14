---
description: Steelmans a technical decision you've already made, then presents the strongest counterargument. Use to stress-test choices before committing to them.
argument-hint: [the decision you've made]
disable-model-invocation: true
---

# Decision Review

The user has made this decision: $ARGUMENTS

## Step 1 — Steelman the decision

Make the strongest possible case *for* this decision. Assume it's correct. Argue it as a knowledgeable advocate would — using concrete benefits, relevant tradeoffs it navigates well, and why alternatives fall short in this context.

Don't hedge. Don't qualify. Make the best case you can.

## Step 2 — The strongest counterargument

Now make the strongest honest case *against* it. Not nitpicking — identify the single most serious risk, limitation, or situation where this decision is likely to cause real pain.

Be specific. "It might not scale" is weak. "This approach serializes all writes through a single lock, which will become a bottleneck above ~500 concurrent users given your current architecture" is useful.

## Step 3 — What to watch for

Given the counterargument, name one concrete signal or threshold that would indicate the decision is becoming a problem. Something the user can actually observe or measure.

---

After both sides are laid out, ask: "Does the counterargument change anything, or does the decision still hold?"
