import { architectures } from "@/lib/architectures";

export default function Catalog() {
  return (
    <section className="px-6 py-12 max-w-6xl mx-auto">
      <h2 className="text-2xl md:text-3xl font-semibold mb-2">The catalog</h2>
      <p className="text-white/55 mb-10 max-w-2xl">
        Click any card to open the full page on GitHub. Every architecture follows the same
        eight-section template — easy to skim, easy to compare.
      </p>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {architectures.map((a) => (
          <a
            key={a.id}
            href={a.href}
            target="_blank"
            rel="noopener noreferrer"
            className="card p-6 block"
          >
            <div className="flex items-baseline justify-between">
              <span className="text-3xl font-mono text-white/25">{a.number}</span>
              <span className="text-xs text-white/40">{a.pattern}</span>
            </div>
            <h3 className="text-xl font-semibold mt-2 mb-3">{a.title}</h3>
            <p className="text-sm text-white/70 leading-relaxed">{a.summary}</p>

            <div className="flex flex-wrap gap-1.5 mt-4">
              {a.tags.map((t) => (
                <span key={t} className="tag">{t}</span>
              ))}
            </div>

            <div className="grid grid-cols-3 gap-2 mt-5 text-xs">
              <div className="rounded-lg bg-white/3 border border-white/5 p-3">
                <div className="text-white/40 uppercase tracking-wider mb-1">S — pilot</div>
                <div className="font-mono text-white/80">{a.scale.s}</div>
              </div>
              <div className="rounded-lg bg-white/3 border border-white/5 p-3">
                <div className="text-white/40 uppercase tracking-wider mb-1">M — team</div>
                <div className="font-mono text-white/80">{a.scale.m}</div>
              </div>
              <div className="rounded-lg bg-white/3 border border-white/5 p-3">
                <div className="text-white/40 uppercase tracking-wider mb-1">L — scale</div>
                <div className="font-mono text-white/80">{a.scale.l}</div>
              </div>
            </div>

            <p className="text-xs text-white/40 mt-4">Best for: {a.bestFor}</p>
          </a>
        ))}
      </div>
    </section>
  );
}
