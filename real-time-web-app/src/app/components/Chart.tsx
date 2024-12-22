"use client";

import React, { useEffect } from "react";
import { Line } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import { getHour } from "../utils/formatDate";

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

export const Chart = ({ messages }: { messages: any[] }) => {
  const [displayData, setDisplayData] = React.useState<any>({
    labels: [],
    datasets: [],
  });

  useEffect(() => {
    setDisplayData({
      ...displayData,
      labels: [
        ...messages.map((item: any) =>
          item.timestamp ? getHour(item.timestamp) : ""
        ),
      ],
      datasets: [
        {
          ...displayData.datasets[0],
          label: "BTC/USD Trade Prices",
          data: messages.map((item: any) => item.price),
        },
      ],
    });
  }, [messages]);

  const options = {
    responsive: true,
    plugins: {
      legend: {
        display: true,
        position: "top" as any, // TS issue on string vs enum
      },
      title: {
        display: true,
        text: "BTC/USD Trade Prices",
      },
    },
    scales: {
      x: {
        title: {
          display: true,
          text: "Time",
        },
      },
      y: {
        title: {
          display: true,
          text: "Price ($)",
        },
        beginAtZero: false,
      },
    },
  };

  return (
    <>
      <Line
        className="chart shadow-xl ring-1 ring-gray-900/5 sm:rounded-lg"
        data={displayData}
        options={options}
      />
    </>
  );
};
