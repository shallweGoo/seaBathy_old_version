function structOfPosAndSignal = getSignalAndSetInfo(picInfo,Height,Width)
    structOfPosAndSignal.y = Height;
    structOfPosAndSignal.x = Width;
    structOfPosAndSignal.signal = picInfo.afterFilter{Height,Width};
end

