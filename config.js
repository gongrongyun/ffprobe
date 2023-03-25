const defaultConfig = {
  corePath: "/dist",
  defaultArgs: ["ffprobe", "-hide_banner", "-of", "json"],
};

const mergeConfig = (config) => {
  return { ...defaultConfig, ...config };
};

export default mergeConfig;
