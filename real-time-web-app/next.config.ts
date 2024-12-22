import { REAL_TIME_SERVER } from "@/app/constants";
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  env: {
    REAL_TIME_SERVER: process.env.REAL_TIME_SERVER,
  },
};

export default nextConfig;
