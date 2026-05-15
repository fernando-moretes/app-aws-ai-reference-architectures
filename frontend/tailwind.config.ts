import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        bg: "#0a0a0f",
        panel: "#11111a",
        accent: "#8b5cf6",
        accent2: "#f97316",
      },
    },
  },
  plugins: [],
};

export default config;
