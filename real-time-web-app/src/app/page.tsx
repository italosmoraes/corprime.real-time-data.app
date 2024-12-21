import Image from "next/image";
import { RealTimeData } from "./RealTimeData";
import { RealTimeBinanceData } from "./RealTimeBinanceData";
import { Chart } from "./Chart";

export default function Home() {
  return (
    <>
      {/* <ChartExample />
      <hr /> */}
      {/* <RealTimeData /> */}
      {/* <hr /> */}
      <RealTimeBinanceData />
    </>
  );
}
