const setup = async (options) => {
  const { corePath } = options;
  const { CreateFFprobe } = await import(corePath);
  const instance = await CreateFFprobe({
    importScriptsOrBlob: corePath,
    locateFile: (path) => {
      if (path.includes("wasm")) {
        return corePath + path;
      }
      return path;
    },
  });

  const ffprobe = instance.cwrap("_main", "number", ["number", "number"]);

  return {};
};
