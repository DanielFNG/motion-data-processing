tic;
n_files = 30;
n_context_parameters = 2;
max = [3,5];
n_trials = 2;

start = ones(n_files, n_context_parameters + 1);



for i=2:n_files
    if start(i-1, end) == n_trials
        for j=n_context_parameters:-1:1
            if start(i-1, j) ~= max(j)
                start(i, :) = start(i-1, :);
                start(i, j) = start(i-1, j) + 1;
                start(i, j+1:end) = 1;
                break
            end
        end
    else
        start(i, :) = start(i-1, :);
        start(i, end) = start(i-1, end) + 1;
    end
end
toc
tic;
combvec([1,2,3],[1,2,3,4,5],[1,2]);
toc