function produceStatic(static_trc, output)

markers = Data(static_trc);

la_jc = getMidpoint(markers, 'L_Ankle_Med', 'L_Ankle_Lat');
ra_jc = getMidpoint(markers, 'R_Ankle_Med', 'R_Ankle_Lat');
lk_jc = getMidPoint(markers, 'L_Knee_Med', 'L_Knee_Lat');
rk_jc = getMidPoint(markers, 'R_Knee_Med', 'R_Knee_Lat');
[rh_jc, lh_jc] = getHJCHarrington(markers);

labels = {'LAJC', 'RAJC', 'LHJC', 'RHJC', 'LKJC', 'RKJC'};
values = [la_jc, ra_jc, lh_jc, rh_jc, lk_jc, rk_jc];

static = markers.extend(labels, values);
static.writeToFile(output);
end

