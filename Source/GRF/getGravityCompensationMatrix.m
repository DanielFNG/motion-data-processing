function mat = getGravityCompensationMatrix(file, inclination)

    S = load(file);
    mat = S.M{S.conv(inclination)};

end