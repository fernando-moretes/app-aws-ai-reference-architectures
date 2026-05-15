export default function Footer() {
  return (
    <footer className="px-6 py-16 max-w-6xl mx-auto border-t border-white/5 mt-12">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div>
          <h3 className="text-lg font-semibold mb-2">Fernando Francisco Azevedo</h3>
          <p className="text-sm text-white/60 max-w-md">
            Solution Architect with focus on AWS and AI/GenAI. Available for solution architecture
            consulting and senior engineering work.
          </p>
        </div>
        <div className="flex flex-col gap-2 md:items-end text-sm">
          <a className="text-white/80 hover:text-accent" href="mailto:fernando@moretes.com">fernando@moretes.com</a>
          <a className="text-white/80 hover:text-accent" href="https://www.linkedin.com/in/fernando-francisco-azevedo/" target="_blank" rel="noopener noreferrer">LinkedIn — fernando-francisco-azevedo</a>
          <a className="text-white/80 hover:text-accent" href="https://github.com/fernandofatech" target="_blank" rel="noopener noreferrer">GitHub — @fernandofatech</a>
          <a className="text-white/80 hover:text-accent" href="https://fernando.moretes.com" target="_blank" rel="noopener noreferrer">fernando.moretes.com</a>
        </div>
      </div>
      <p className="text-xs text-white/30 mt-10">© 2026 Fernando Francisco Azevedo · MIT License</p>
    </footer>
  );
}
