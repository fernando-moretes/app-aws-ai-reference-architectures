import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "AWS AI Reference Architectures",
  description:
    "Six production-shaped reference architectures for AI workloads on AWS — diagrams, decisions, Terraform skeletons, cost analysis and Well-Architected reviews.",
  authors: [{ name: "Fernando Francisco Azevedo", url: "https://fernando.moretes.com" }],
  openGraph: {
    title: "AWS AI Reference Architectures",
    description: "Six reference architectures for AI on AWS.",
    url: "https://aws-ai-reference-architectures.vercel.app",
    siteName: "AWS AI Reference Architectures",
    type: "website",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
