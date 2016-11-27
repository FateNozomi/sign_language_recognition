% Load database.mat if database does not exist
if ~exist('database','var')
    % get 2-D array database
    load('database.mat');
end

% Get databaseOpen and databaseClosed
databaseOpen = database{1};
databaseOpen = double(databaseOpen);
databaseClosed = database{2};
databaseClosed = double(databaseClosed);

% Get the number of columns in both database
colDatabaseOpen = size(databaseOpen,2);
dboMean = mean(databaseOpen,1);
dboMA = bsxfun(@minus, databaseOpen, dboMean); %databaseOpen Mean Adjusted
colDatabaseClosed = size(databaseClosed,2);
dbcMean = mean(databaseClosed,1);
dbcMA = bsxfun(@minus, databaseClosed, dbcMean); %databaseClosed Mean Adjusted

% --- Find the principal components aka eigenhands.
covarianceO=cov(dboMA');
[coeff1, latent1] = eig(covarianceO);
[latent1,idx] = sort(diag(latent1), 'descend'); %Sort eigenvalues
coeff1 = coeff1(:,idx); %Sort eigenvectors based on the eigenvalues
cumLatent1 = cumsum(latent1); % cumulative sum of eigenvalues
varianceO = cumLatent1/sum(latent1); % variance percentage for open

%Calculate the total number of eigenvectors required to represent 95% of
%the total variance of all hand images.
maxCoeff1 = 0;
for i = 1:length(varianceO)
    if varianceO(i) < 0.95
        maxCoeff1 = maxCoeff1 + 1;
    else
        break
    end
end

covarianceC=cov(dbcMA');
[coeff2, latent2] = eig(covarianceC);
[latent2,idx] = sort(diag(latent2), 'descend'); %Sort eigenvalues
coeff2 = coeff2(:,idx); %Sort eigenvectors based on the eigenvalues
cumLatent2 = cumsum(latent2); % cumulative sum of eigenvalues
varianceC = cumLatent2/sum(latent2); % variance percentage for closed

maxCoeff2 = 0;
for i = 1:length(varianceC)
    if varianceC(i) < 0.95
        maxCoeff2 = maxCoeff2 + 1;
    else
        break
    end
end

coeff1 = coeff1(:,1:maxCoeff1);
featuresOpen = coeff1'*dboMA;
coeff2 = coeff2(:,1:maxCoeff2);
featuresClosed = coeff2'*dbcMA;

save('features','coeff1','coeff2','featuresOpen','featuresClosed');