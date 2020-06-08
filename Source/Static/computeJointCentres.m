function static = computeJointCentres(static)

    la_jc = getMidpoint(static, 'L_Ankle_Med', 'L_Ankle_Lat');
    ra_jc = getMidpoint(static, 'R_Ankle_Med', 'R_Ankle_Lat');
    lk_jc = getMidpoint(static, 'L_Knee_Med', 'L_Knee_Lat');
    rk_jc = getMidpoint(static, 'R_Knee_Med', 'R_Knee_Lat');
    [rh_jc, lh_jc] = getHJCHarrington(static);

    labels = {'LAJC', 'RAJC', 'LHJC', 'RHJC', 'LKJC', 'RKJC'};
    values = [la_jc, ra_jc, lh_jc, rh_jc, lk_jc, rk_jc];

    static.extend(labels, values);

end