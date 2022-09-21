---
title: "Why Cloud?"
menuTitle: "Why Cloud?"
weight: 5
---

## Summary of Key Cloud Advantages

![Cloud Benefits](/images/cloud-benefits.png)

Worth of note: cloud adds the ability for any developer to build any solution - from PoC all the way to a production systems - without being dependent on many other teams.

## Gotchas

It is easy to make mistakes that can negate these benefits.  Here are some things to be mindful of:

- **Stick to open source** where possible.  Avoid using proprietary licensed code.  Licensed products will typically eliminate almost all of the scalability and elasticity benefit. (Consider where you might have to buy enough licenses to cover your peak utilisation.)
- **Stick to cloud native and/or fully-managed services** where possible.  E.g. if you need a relational database, consider a cloud native solution or a fully-managed solution.  That way, all deployment, maintenance, patching, and security are taken care of.  Don't build your own on IaaS.  If you do that, you need to manage and patch your operating systems, and then manage and patch software deployed to them (e.g. databases).
- **Always build with automation.** One of the main advantages of cloud is that it is software defined.  This means we can build infrastructure using code. And this means our builds can be repeatable, consistent and fast.  It also means that the infrastructure-as-code (IaC) is self-documenting, reducing the need for heavy low-level design docs.  Avoid building by hand; this leads to configuration drift.
- **Turn off services that are not in use.**  Pay for what you use!
