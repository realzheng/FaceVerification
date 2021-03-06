num = size(AllFeature1,2);
F1 = AllFeature1';
% F1 = (F11>0);
% F1 = sign(F1) .* sqrt(abs(F1));
F1 = bsxfun(@rdivide, F1, sqrt(sum(F1.^2,2)));
% F1 = bsxfun(@minus,F1,PCAmap.mean);
% F1 = F1 * PCAmap.M;
F2 = AllFeature2';
% F2 = (F21>0);
% F2 = sign(F1) .* sqrt(abs(F2));
F2 = bsxfun(@rdivide, F2, sqrt(sum(F2.^2,2)));
% F2 = bsxfun(@minus,F2,PCAmap.mean);
% F2 = F2 * PCAmap.M;
% F1 = AllFeature1';
% F2 = AllFeature2';
thresh2 = zeros(num,1);
for i = 1:num
%     thresh2(i) = F1(i,:) * mapping.A * F1(i,:)' + F2(i,:) * mapping.A * F2(i,:)' - 2 * F1(i,:) * mapping.G * F2(i,:)';
    thresh2(i) = pdist2(F1(i,:),F2(i,:));
%     thresh2(i) = F1(i,:) * F2(i,:)';
end;
figure;
hist(thresh2(1:3000),500);
figure;
hist(thresh2(3001:end),500);

accuracies = zeros(10,1);
for i=1:10
    test_idx = [(i-1) * 300 + 1 : i*300, (i-1) * 300 + 3001 : i*300 + 3000];
    train_idx = 1:6000;
    train_idx(test_idx) = [];
    bestc=256;
    same_label = ones(6000,1);
    same_label(3001:6000) = 0;
    % predicted_label = predict(double(lfw_label),sparse(thresh2),model);
    cmd = [' -t 0 -h 0'];
    model = svmtrain(same_label(train_idx),thresh2(train_idx),cmd);
    % model = svmtrain(double(sim_label),thresh,cmd);
    [class, accuracy, deci] = svmpredict(same_label(test_idx),thresh2(test_idx),model);
    accuracies(i) = accuracy(1);
end;
mean(accuracies)
cmd = [' -t 0 -h 0'];
model = svmtrain(same_label,thresh2,cmd);
[class, accuracy, deci] = svmpredict(same_label,thresh2,model);
% mean(thresh2(same_label==1)) / 4 + mean(max(0,1 - thresh2(same_label==0))) / 4
% sum((thresh2<0.22) == same_label) / 6000