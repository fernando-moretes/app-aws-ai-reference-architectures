const sections = [
  ["Problem statement", "One paragraph. If this isn't your situation, the rest probably isn't either."],
  ["Components", "Bullet list of services with one-line rationale per service."],
  ["Diagram", "One Mermaid view of the whole pattern."],
  ["Decisions", "The 3–5 calls that shape the design. MADR-light: context, decision, alternatives, consequences."],
  ["Cost analysis", "S/M/L table with inputs spelled out. Recompute if you disagree with assumptions."],
  ["Well-Architected", "Salient findings across the six pillars. Treat as a checklist primer."],
  ["Trade-offs", "Use this when... and Do NOT use this when... — the negative list is the most valuable section."],
  ["Terraform skeleton", "Resources + wiring. Names, tags, IAM boundaries and state backend are deliberately omitted."],
];

export default function HowToRead() {
  return (
    <section className="px-6 py-16 max-w-6xl mx-auto">
      <h2 className="text-2xl md:text-3xl font-semibold mb-2">How to read these</h2>
      <p className="text-white/55 mb-10 max-w-2xl">Eight sections, always in this order. Skip to the one that matches what you came for.</p>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {sections.map(([t, b]) => (
          <div key={t} className="card p-5">
            <div className="text-sm font-semibold text-accent">{t}</div>
            <p className="text-sm text-white/70 mt-1 leading-relaxed">{b}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
