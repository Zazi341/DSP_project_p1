function x = IFFT_recursive_FFT(X)
    % Conjugate the input
    X_conj = conj(X);
    
    % Apply the FFT to the conjugated input
    x_conj = FFT_recursive(X_conj);
    
    % Conjugate the result and scale
    x = conj(x_conj) / length(X);
end