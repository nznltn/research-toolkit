% This script shows a simple randomisation routine for experimental studies where the order of replicates or samples in the analysis might matter (so random sorting is desired). 
% It is designed to be interactive and can be operated by a user who is only little familiar with coding. 

%% The routine section
a=input('Was instrument-1 in site-1 used? Enter yes (y) or no (n):', 's');
if a=='y'
    b=input('How many groups of samples?');
    name=input('Please enter the names of the sample groups with commas in between:', 's');
    c=input('Are the numbers of replicates the same for each group? Enter yes (y) or no (n):', 's');
    if c=='y'
    n=input('How many replicates in each group?');
    a2=ones(b,n);
    for i=1:b
    a2(i,:)=randperm(n,n);
    end 
    disp('Randomized order of samples are below:')
    disp(name)
    disp([a2'])
    elseif c=='n'
        m=input('Enter the number of samples in each group, in a [] with spaces:');
        a2=zeros(b, max(m));
        for i=1:b
            a2(i,1:m(1,i))=randperm(m(1,i), m(1,i))';
        end
        a2c=num2cell(a2);
        namecell=strsplit(name, ',');
        T=cell2table(a2c');
        T.Properties.VariableNames = namecell;
        disp('Randomized order of samples are below:')
            disp(T)
    end
elseif a=='n'
    disp('This instrument in above indicated site was not used to analyse these samples.')
end
 
