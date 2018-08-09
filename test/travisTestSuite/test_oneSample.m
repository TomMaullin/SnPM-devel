% Perform non-regression tests on one sample tests in SnPM. 
% Check that results obtained using the batch version are identical to the 
% results computed manually (using the interactive GUI).

% TODO: add generic_test_snpm()

```matlab
function test_suite=my_test_of_abs
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

end


function testCase=setupBatch

    % read in the generic batch template
    testCase = generic_test_snpm();
    testCase.numBetas = 1;
    
    for i = 1:5
        testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.P{i,1} = ...
             fullfile(testCase.testDataDir, ['test_data_' num2str(i, '%02.0f') '.nii']);
    end
    
end

function additional_results(testCase)
    % Rename uncorrected p<0.1
    testCase.matlabbatch{end}.spm.tools.snpm.inference.WriteFiltImg.name = 'SnPMt_filtered_vox_unc_p10.nii';
    
    % Uncorrected voxel-wise TorF > 1.6
    testCase.matlabbatch{end+1}.spm.tools.snpm.inference.SnPMmat(1) = cfg_dep;
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).tname = 'SnPM.mat results file';
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).tgt_spec = {};
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).sname = 'Compute: SnPM.mat results file';
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).src_output = substruct('.','SnPM');
    testCase.matlabbatch{end}.spm.tools.snpm.inference.Thr.Vox.VoxSig.TFth = 1.6;
    testCase.matlabbatch{end}.spm.tools.snpm.inference.WriteFiltImg.name = 'SnPMt_filtered_vox_unc_t16.nii';
    
    % FWE voxel-wise p<0.5
    testCase.matlabbatch{end+1}.spm.tools.snpm.inference.SnPMmat(1) = cfg_dep;
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).tname = 'SnPM.mat results file';
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).tgt_spec = {};
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).sname = 'Compute: SnPM.mat results file';
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).src_output = substruct('.','SnPM');
    testCase.matlabbatch{end}.spm.tools.snpm.inference.Thr.Vox.VoxSig.FWEth = 0.1;
    testCase.matlabbatch{end}.spm.tools.snpm.inference.WriteFiltImg.name = 'SnPMt_filtered_vox_fwe_p10.nii'; 
    
    % FDR voxel-wise p<0.5
    testCase.matlabbatch{end+1}.spm.tools.snpm.inference.SnPMmat(1) = cfg_dep;
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).tname = 'SnPM.mat results file';
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).tgt_spec = {};
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).sname = 'Compute: SnPM.mat results file';
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    testCase.matlabbatch{end}.spm.tools.snpm.inference.SnPMmat(1).src_output = substruct('.','SnPM');
    testCase.matlabbatch{end}.spm.tools.snpm.inference.Thr.Vox.VoxSig.FDRth = 0.7;
    testCase.matlabbatch{end}.spm.tools.snpm.inference.WriteFiltImg.name = 'SnPMt_filtered_vox_fdr_p70.nii';  
end

function test_onesample_1

    testCase = setupBatch();
    testCase.testName = 'onesample_1';
    
    % Test FDR, FWE et uncorrected T thresh as well
    additional_results(testCase);
end

// classdef test_oneSample < generic_test_snpm
//     properties
//     end
    
//     methods (TestMethodSetup)
//         function create_basis_matlabbatch(testCase)
//             testCase.numBetas = 1;
            
//             for i = 1:5
//                 testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.P{i,1} = ...
//                      fullfile(testCase.testDataDir, ['test_data_' num2str(i, '%02.0f') '.nii']);
//             end
//         end
//     end

//     methods (Test)
//         % No covariate, no variance smoothing, no cluster stat
//         function test_onesample_1(testCase)
//             testCase.testName = 'onesample_1';
            
//             % Test FDR, FWE et uncorrected T thresh as well
//             additional_results(testCase);
//         end
        
//         % No covariate, no variance smoothing, no cluster stat
//         % Missing extension in results should not cause error
//         function test_onesample_no_ext_in_results(testCase)
//             testCase.testName = 'onesample_no_ext_in_results';
            
//             % Test FDR, FWE et uncorrected T thresh as well
//             additional_results(testCase);
//         end
        
//         % No covariate, no variance smoothing and cluster stat
//         function test_onesample_cluster(testCase)
//             testCase.testName = 'onesample_cluster';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 1;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.ST.ST_later = -1;
            
//             % Test FDR, FWE and uncorrected T thresh as well
//             additional_results(testCase);
//             % Test cluster size statistic
//             additional_cluster_results(testCase);
//             % Test cluster mass statistic
//             additional_cluster_mass_results(testCase);
//         end

//         % No covariate, no variance smoothing and cluster stat with
//         % pre-defined height threshold
//         function test_onesample_cluster_predefined(testCase)
//             testCase.testName = 'onesample_cluster_predefined';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 1;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.ST.ST_U = 0.1;
            
//             additional_predefined_cluster_results(testCase);
//         end
        
//         % No covariate, with variance smoothing and cluster stat with
//         % pre-defined height threshold
//         function test_onesample_var_cluster_predefined(testCase)
//             % Conversion to statistic using Normal distribution was 
//             % introduced in SnPM13 and can therefore not be tested
//             % for non-regression with SnPM8            
//             testCase.checks = false;
            
//             testCase.warningId = 'snpm_cp:pseudoTFormingThresholdP';
            
//             % Cannot compare with SPM as we have variance smoothing            
//             testCase.compaWithSpm = false;
            
//             testCase.testName = 'onesample_var_cluster_predefined';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.vFWHM = [6 6 6];
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 1;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.ST.ST_U = 0.1;
            
//             additional_predefined_cluster_results(testCase);
//         end
        
//         % No covariate, no variance smoothing and cluster stat with
//         % pre-defined height threshold as a statistic value
//         function test_onesample_cluster_slow(testCase)
//             testCase.testName = 'onesample_cluster_slow';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 1;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.ST.ST_later = -1;
            
//             additional_predefined_cluster_results(testCase);
//             % Slow => need to specify cluster-forming threshold
//             testCase.matlabbatch{end-1}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 3.8;
//             testCase.matlabbatch{end}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 3.8;
//         end
        
//         % No covariate, variance smoothing and cluster stat with
//         % pre-defined height threshold as a statistic value
//         function test_onesample_cluster_slow_var(testCase)
//             testCase.testName = 'onesample_cluster_slow_var';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.vFWHM = [6 6 6];
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 1;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.ST.ST_later = -1;
            
//             additional_predefined_cluster_results(testCase);
//             % Slow => need to specify cluster-forming threshold
//             testCase.matlabbatch{end-1}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 3.8;
//             testCase.matlabbatch{end}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 3.8;
//         end
        
//         % No covariate, variance smoothing and cluster stat with
//         % pre-defined height threshold as a statistic value
//         function test_onesample_cluster_slow_var_threshP(testCase)
//             % Conversion to statistic using Normal distribution was 
//             % introduced in SnPM13 and can therefore not be tested
//             % for non-regression with SnPM8            
//             testCase.checks = false;
            
//             testCase.warningId = 'snpm_pp:pseudoTFormingThresholdP';
            
//             % Cannot compare with SPM as we have variance smoothing            
//             testCase.compaWithSpm = false;
            
//             testCase.testName = 'onesample_cluster_slow_var_threshP';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.vFWHM = [6 6 6];
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 1;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.ST.ST_later = -1;
            
//             additional_predefined_cluster_results(testCase);
//             % Slow => need to specify cluster-forming threshold
//             testCase.matlabbatch{end-1}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 0.01;
//             testCase.matlabbatch{end}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 0.01;
//         end
        
        
//         % With 1 covariate
//         function test_onesample_cov(testCase)
//             testCase.testName = 'onesample_cov';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov.c = [1 5 2 21 0];
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov.cname = 'age';
//         end

//         % With 3 covariates
//         function test_onesample_cov3(testCase)
//             testCase.testName = 'onesample_cov3';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov(1).c = [1 1 2 3 1];
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov(1).cname = 'age';
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov(2).c = [0 21 15 18 3];
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov(2).cname = 'height';
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov(3).c = [-1 -0.5 -1 1 0];
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.cov(3).cname = 'width';
//         end

//         % With variance smoothing
//         function test_onesample_var(testCase)
//             testCase.testName = 'onesample_var';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.vFWHM = [6 6 6];
//         end
        
//         % With absolute masking
//         function test_onesample_abs_thresh(testCase)
//             testCase.testName = 'onesample_abs_thresh';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.masking.tm.tma.athresh = 0.1;
//         end
        
//         % With proportional masking
//         function test_onesample_prop_thresh(testCase)
//             testCase.compaWithSpm = true;
//             testCase.testName = 'onesample_prop_thresh';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.masking.tm.tmr.rthresh = 0.75;
//         end

//         % With masking using an image
//         function test_onesample_mask(testCase)
//             testCase.testName = 'onesample_mask';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.masking.em =...
//                 {fullfile(testCase.testDataDir, 'mask.nii,1')};
//         end
        
//         % With approximate test
//         function test_onesample_approx(testCase)
//             testCase.testName = 'onesample_approx';
            
//             try
//                 % Syntax for newest Matlab versions
//                 rng(200);
//             catch
//                 % Old syntax
//                 rand('seed',200);
//             end
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.nPerm = 15;
//         end
        
//         % Global normalisation, normalisation: Proportional scaling scaled 
//         % to default value (50)
//         function test_onesample_propscaling(testCase)
//             testCase.testName = 'onesample_propscaling';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.globalm.glonorm = 2;
//         end
        
//         % Global normalisation, normalisation: Proportional scaling scale 
//         % to user-defined value
//         function test_onesample_propscaling_to_user(testCase)
//             testCase.testName = 'onesample_propscaling_to_user';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.globalm.glonorm = 2;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.globalm.gmsca.gmsca_yes.gmscv = 145;
//         end

//         % Global normalisation: overall grand mean scaling to 145
//         function test_onesample_grandmean_145(testCase)
//             testCase.testName = 'onesample_grandmean_145';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.globalm.gmsca.gmsca_yes.gmscv = 145;
//         end
        
//         % Global normalisation: overall grand mean scaling to 50
//         function test_onesample_grandmean_50(testCase)
//             testCase.testName = 'onesample_grandmean_50';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.globalm.gmsca.gmsca_yes.gmscv = 50;
//         end
        
//         % Global normalisation, normalisation: ANCOVA
//         function test_onesample_ancova(testCase)
//             testCase.testName = 'onesample_ancova';
            
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.globalm.glonorm = 3;
//         end
        
//         % Work slice by slice
//         function test_onesample_slice(testCase)
//             testCase.compaWithSpm = false;
            
//             testCase.testName = 'onesample_slice';
            
//             try
//                 rng(200);
//             catch
//                 rand('seed',200);
//             end
//             for i = 6:17
//                 testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.P{end+1} = ...
//                     fullfile(testCase.testDataDir, ['test_data_' num2str(i, '%02.0f') '.nii']);
//             end
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.nPerm = 15;
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.bVolm = 0;
//         end
        
//     end
    
//     methods
//         function complete_batch(testCase)
//             % Find the result directory for the batch execution and the
//             % corresponding result directory computed manually using the
//             % original spm2-like interface
//             testCase.batchResDir = fullfile(testCase.parentDataDir, 'results', 'batch', testCase.testName);
//             testCase.matlabbatch{1}.spm.tools.snpm.des.OneSampT.dir = {testCase.batchResDir};
//         end
        
//         function create_spm_batch(testCase)
//             factoDesign = testCase.spmBatch{1}.spm.stats.factorial_design;
            
//             factoDesign.des.t1.scans = factoDesign.P;
//             factoDesign = rmfield(factoDesign, 'P');
            
//             testCase.spmBatch{1}.spm.stats.factorial_design = factoDesign;
//         end
//     end
// end