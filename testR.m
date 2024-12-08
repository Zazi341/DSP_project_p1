function testR()
    % Example signal
    x = [1, 2, 3, 4, 5, 6, 7, 8];

    % Recursive FFT
    X_recursive = FFT_recursive(x);

    % MATLAB's FFT
    X_builtin = fft(x);

    % Plot the magnitude of both FFT results for comparison
    figure;
    
    subplot(2, 1, 1);
    stem(0:length(x)-1, abs(X_recursive), 'filled');
    title('Custom Recursive FFT');
    xlabel('Index');
    ylabel('Magnitude');
    
    subplot(2, 1, 2);
    stem(0:length(x)-1, abs(X_builtin), 'filled');
    title('MATLAB FFT');
    xlabel('Index');
    ylabel('Magnitude');

    % Print the results to the terminal
    disp('Custom Recursive FFT Result:');
    disp(X_recursive);
    
    disp('MATLAB FFT Result:');
    disp(X_builtin);

    % Display the difference
    disp('Difference between custom FFT and MATLAB FFT:');
    disp(norm(X_recursive - X_builtin));

    % Recursive IFFT
    x_recursive_ifft = IFFT_recursive_FFT(X_recursive);

    % MATLAB's IFFT
    x_builtin_ifft = ifft(X_builtin);

    % Plot the magnitude of both IFFT results for comparison
    figure;
    
    subplot(2, 1, 1);
    stem(0:length(x)-1, abs(x_recursive_ifft), 'filled');
    title('Custom Recursive IFFT');
    xlabel('Index');
    ylabel('Magnitude');
    
    subplot(2, 1, 2);
    stem(0:length(x)-1, abs(x_builtin_ifft), 'filled');
    title('MATLAB IFFT');
    xlabel('Index');
    ylabel('Magnitude');

    % Print the results to the terminal
    disp('Custom Recursive IFFT Result:');
    disp(x_recursive_ifft);
    
    disp('MATLAB IFFT Result:');
    disp(x_builtin_ifft);

    % Display the difference
    disp('Difference between custom IFFT and MATLAB IFFT:');
    disp(norm(x_recursive_ifft - x_builtin_ifft));
end