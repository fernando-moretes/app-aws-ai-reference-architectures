export default function Hero() {
  return (
    <section className="px-6 pt-20 pb-12 md:pt-32 md:pb-16 max-w-6xl mx-auto">
      <div className="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs text-white/70 mb-6">
        <span className="h-2 w-2 rounded-full bg-accent"></span>
        6 architectures · MIT license · v0.1.0
      </div>
      <h1 className="text-4xl md:text-6xl font-semibold tracking-tight">
        Reference architectures for <span className="gradient-text">AI on AWS</span>,
        <br />
        opinionated and unboring.
      </h1>
      <p className="text-lg md:text-xl text-white/70 max-w-3xl mt-6">
        Six production-shaped patterns. Each one in ten minutes: problem, components, diagram,
        the decisions that matter, cost at three scales, Well-Architected review, trade-offs and
        a Terraform skeleton. Not a 200-page white paper. Not a toy notebook.
      </p>
      <div className="flex flex-wrap gap-3 pt-8">
        <a
          href="https://github.com/fernandofatech/aws-ai-reference-architectures"
          className="inline-flex items-center gap-2 rounded-lg bg-accent px-4 py-2.5 text-sm font-medium hover:bg-accent/90 transition"
        >
          View on GitHub →
        </a>
        <a
          href="https://fernandofatech.github.io/aws-ai-reference-architectures/"
          className="inline-flex items-center gap-2 rounded-lg border border-white/15 bg-white/5 px-4 py-2.5 text-sm font-medium hover:bg-white/10 transition"
        >
          Browse the docs
        </a>
      </div>
    </section>
  );
}
