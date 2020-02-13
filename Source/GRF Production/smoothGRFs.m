function [forces, moments] = smoothGRFs(forces, moments)

    for i=[0,3]
        forces(:, i + 1) = smooth(forces(:, i + 1), 15);
        forces(:, i + 2) = smooth(forces(:, i + 2), 5);
        forces(:, i + 3) = smooth(forces(:, i + 3), 10);
        moments(:, i + 1) = smooth(moments(:, i + 1), 15);
        moments(:, i + 3) = smooth(moments(:, i + 3), 10);
    end

end