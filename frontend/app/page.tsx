import Hero from "@/components/Hero";
import Catalog from "@/components/Catalog";
import HowToRead from "@/components/HowToRead";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <main className="min-h-screen">
      <Hero />
      <Catalog />
      <HowToRead />
      <Footer />
    </main>
  );
}
