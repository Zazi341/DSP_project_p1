function X = FFT_recursive(x)
    N = length(x);
    if N <= 1
        X = x;
    else
        % Split the input into even and odd indexed parts
        even_part = x(1:2:end);
        odd_part = x(2:2:end);

        % Recursive FFT on even and odd parts
        G = FFT_recursive(even_part);
        H = FFT_recursive(odd_part);

        % Combine the results
        W_N = exp(-2i * pi * (0:N/2-1) / N);
        X = [G + W_N .* H, G - W_N .* H];
    end
end