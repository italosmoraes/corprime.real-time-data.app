export const getHour = (timestamp: number) => {
  const formattedDate = new Date(timestamp).toLocaleString("en-UK", {
    hour: "2-digit", // Hour in 2-digit format
    minute: "2-digit", // Minute in 2-digit format
    second: "2-digit", // Second in 2-digit format
    hour12: false, // 24-hour format
  });

  return formattedDate;
};
