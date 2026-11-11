% works for WAV and FLAC
function [x, fs, bitsPerRawSample] = loadAudio(file)

info = audioinfo(file);
bitsPerRawSample = info.BitsPerSample;

[raw, fs] = audioread(file, 'native');
assert(isinteger(raw), ...
    'load_audio: %s holds %s samples, not integer PCM', file, class(raw));

x = double(raw);

% adjust based on data type
% I guess samples sometimes are
% left-justified for 24-bit
switch class(raw)
    case 'uint8'
        x = x - 128;
    case 'int32'
        if bitsPerRawSample < 32
            scale = 2^(32 - bitsPerRawSample);
            if all(mod(x(:), scale) == 0)
                x = x / scale;
            end
        end
end
end
