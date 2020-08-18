//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.example.android_svm_test_home;

import android.os.Environment;
import com.example.android_svm_test_home.svm_train;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import libsvm.svm;
import libsvm.svm_node;

public class AART_Planner_Engine {
    double threshold1_accVar = 8.0E-4D;
    double threshold_pres = 0.4D;
    double threshold2_accVar = 0.8D;
    double threshold3_accVar = 3.0D;
    double threshold1_stepcount = 40.0D;
    double threshold2_stepcount = 20.0D;
    double threshold1_swingcount = 20.0D;
    int large_swing_num_for_golf = 1;
    int min_large_swing_num_for_golf = 1;
    int max_large_swing_num_for_golf = 3;
    int present_1m_activity = 0;
    String root_folder = Environment.getExternalStorageDirectory().getAbsolutePath();
    String file_pos_class_1;
    String file_pos_class_2;
    String file_pos_class_3;
    svm_train s_train_1;
    svm_train s_train_2;
    svm_train s_train_3;
    double svm_estimated_label;
    double step_parameter_scale;
    double alpha;
    double beta;
    double n_ampl;
    double n_fre;
    double SL_0_walking;
    double SL_0_hiking;
    double SL_0_run;
    
    public AART_Planner_Engine() {
        this.file_pos_class_1 = this.root_folder + String.format("/svm/KistracCalssifierV5_2_1.ser", new Object[0]);
        this.file_pos_class_2 = this.root_folder + String.format("/svm/KistracCalssifierV5_2_2.ser", new Object[0]);
        this.file_pos_class_3 = this.root_folder + String.format("/svm/KistracCalssifierV5_2_3.ser", new Object[0]);
        this.s_train_1 = new svm_train();
        this.s_train_2 = new svm_train();
        this.s_train_3 = new svm_train();
        this.svm_estimated_label = 0.0D;
        this.step_parameter_scale = 3.5D;
        this.alpha = 0.32D * this.step_parameter_scale;
        this.beta = 0.72D * this.step_parameter_scale;
        this.n_ampl = 8.7D;
        this.n_fre = 0.94D;
        this.SL_0_walking = 68.0D;
        this.SL_0_hiking = 60.0D;
        this.SL_0_run = 98.0D;
    }
    
    public double[] ActivityOut(double[] feature_element_vector) {
        double[] estimated_activity = new double[8];
        double n_min = 9.0D;
        double n_max = 13.0D;
        double x_min1 = -2.2D;
        double x_max1 = 3.1D;
        double y_min1 = -8.2D;
        double y_max1 = -4.2D;
        double z_min1 = 5.6D;
        double z_max1 = 9.5D;
        double x_min2 = 6.9D;
        double x_max2 = 10.1D;
        double y_min2 = -7.2D;
        double y_max2 = -3.3D;
        double z_min2 = 0.0D;
        double z_max2 = 5.0D;
        double x_min3 = 3.8D;
        double x_max3 = 6.3D;
        double y_min3 = -8.7D;
        double y_max3 = -6.6D;
        double z_min3 = 2.6D;
        double z_max3 = 6.4D;
        if(feature_element_vector[3] < this.threshold1_accVar) {
            this.present_1m_activity = 2;
        } else if(feature_element_vector[3] < this.threshold2_accVar && feature_element_vector[11] == 0.0D) {
            this.present_1m_activity = 4;
        } else {
            double[] svm_feature;
            svm_node[] x;
            int j;
            if((feature_element_vector[3] >= this.threshold3_accVar || feature_element_vector[11] != 0.0D) &&
               (feature_element_vector[3] >= this.threshold3_accVar || Math.abs(feature_element_vector[12]) <= 5.0D)) {
                if(feature_element_vector[11] >= (double)this.large_swing_num_for_golf && feature_element_vector[10] <= 2.0D && feature_element_vector[9] == 0.0D) {
                    this.present_1m_activity = 44;
                } else {
                    svm_feature = new double[]{
                        feature_element_vector[0] / 20.0D,
                        feature_element_vector[3] / 20.0D,
                        feature_element_vector[8] / 20.0D,
                        feature_element_vector[9] / 20.0D,
                        feature_element_vector[8] / (feature_element_vector[9] + 1.0D) / 20.0D,
                        feature_element_vector[4],
                        feature_element_vector[5],
                        feature_element_vector[6],
                        feature_element_vector[7]};
                    x = new svm_node[9];
                    
                    for(j = 0; j < 9; ++j) {
                        x[j] = new svm_node();
                        x[j].index = j + 1;
                        x[j].value = svm_feature[j];
                    }
                    
                    this.svm_estimated_label = svm.svm_predict(this.s_train_3.model, x);
                    if(this.svm_estimated_label == 1.0D) {
                        this.present_1m_activity = 6;
                    } else if(this.svm_estimated_label == 2.0D) {
                        this.present_1m_activity = 6;
                    } else if(this.svm_estimated_label == 3.0D) {
                        this.present_1m_activity = 10;
                    } else if(this.svm_estimated_label == 4.0D) {
                        this.present_1m_activity = 12;
                    } else if(this.svm_estimated_label == 5.0D) {
                        this.present_1m_activity = 14;
                    } else if(this.svm_estimated_label == 6.0D) {
                        this.present_1m_activity = 16;
                    } else if(this.svm_estimated_label == 7.0D) {
                        this.present_1m_activity = 18;
                    } else if(this.svm_estimated_label == 8.0D) {
                        this.present_1m_activity = 20;
                    } else if(this.svm_estimated_label == 9.0D) {
                        this.present_1m_activity = 22;
                    } else if(this.svm_estimated_label == 10.0D) {
                        this.present_1m_activity = 24;
                    } else if(this.svm_estimated_label == 11.0D) {
                        this.present_1m_activity = 26;
                    } else if(this.svm_estimated_label == 12.0D) {
                        this.present_1m_activity = 28;
                    } else if(this.svm_estimated_label == 13.0D) {
                        this.present_1m_activity = 40;
                    } else if(this.svm_estimated_label == 14.0D) {
                        this.present_1m_activity = 42;
                    }
                }
            } else {
                svm_feature = new double[]{feature_element_vector[4], feature_element_vector[5], feature_element_vector[6]};
                x = new svm_node[3];
                
                for(j = 0; j < 3; ++j) {
                    x[j] = new svm_node();
                    x[j].index = j + 1;
                    x[j].value = svm_feature[j];
                }
                
                this.svm_estimated_label = svm.svm_predict(this.s_train_1.model, x);
                if(this.svm_estimated_label == 1.0D) {
                    this.present_1m_activity = 4;
                } else if(this.svm_estimated_label == 2.0D) {
                    this.present_1m_activity = 6;
                }
            }
        }
        
        if(this.present_1m_activity == 6) {
            if(feature_element_vector[4] >= x_min1 && feature_element_vector[4] <= x_max1 && feature_element_vector[5] >= y_min1 && feature_element_vector[5] <= y_max1 && feature_element_vector[6] >= z_min1 && feature_element_vector[6] <= z_max1 && feature_element_vector[7] >= n_min && feature_element_vector[7] <= n_max) {
                this.present_1m_activity = 6;
            } else if(feature_element_vector[4] >= x_min2 && feature_element_vector[4] <= x_max2 && feature_element_vector[5] >= y_min2 && feature_element_vector[5] <= y_max2 && feature_element_vector[6] >= z_min2 && feature_element_vector[6] <= z_max2 && feature_element_vector[7] >= n_min && feature_element_vector[7] <= n_max) {
                this.present_1m_activity = 6;
            } else if(feature_element_vector[4] >= x_min3 && feature_element_vector[4] <= x_max3 && feature_element_vector[5] >= y_min3 && feature_element_vector[5] <= y_max3 && feature_element_vector[6] >= z_min3 && feature_element_vector[6] <= z_max3 && feature_element_vector[7] >= n_min && feature_element_vector[7] <= n_max) {
                this.present_1m_activity = 6;
            } else if(feature_element_vector[8] < 10.0D && feature_element_vector[10] > 30.0D) {
                this.present_1m_activity = 4;
            } else if(feature_element_vector[8] > 20.0D) {
                this.present_1m_activity = 12;
            } else {
                this.present_1m_activity = 4;
            }
        }
        
        if(this.present_1m_activity == 2) {
            estimated_activity[0] = 0.0D;
        } else if(this.present_1m_activity == 4) {
            estimated_activity[0] = 1.0D;
        } else if(this.present_1m_activity == 6) {
            estimated_activity[0] = 2.0D;
        } else if(this.present_1m_activity == 8) {
            estimated_activity[0] = 2.0D;
        } else if(this.present_1m_activity == 10) {
            estimated_activity[0] = 3.0D;
        } else if(this.present_1m_activity == 12) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 14) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 16) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 18) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 20) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 22) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 24) {
            estimated_activity[0] = 4.0D;
        } else if(this.present_1m_activity == 26) {
            estimated_activity[0] = 5.0D;
        } else if(this.present_1m_activity == 28) {
            estimated_activity[0] = 5.0D;
        } else if(this.present_1m_activity == 30) {
            estimated_activity[0] = 6.0D;
        } else if(this.present_1m_activity == 32) {
            estimated_activity[0] = 7.0D;
        } else if(this.present_1m_activity == 34) {
            estimated_activity[0] = 7.0D;
        } else if(this.present_1m_activity == 36) {
            estimated_activity[0] = 7.0D;
        } else if(this.present_1m_activity == 38) {
            estimated_activity[0] = 7.0D;
        } else if(this.present_1m_activity == 40) {
            estimated_activity[0] = 21.0D;
        } else if(this.present_1m_activity == 42) {
            estimated_activity[0] = 20.0D;
        } else if(this.present_1m_activity == 44) {
            estimated_activity[0] = 10.0D;
        }
        
        if(estimated_activity[0] == 1.0D && feature_element_vector[8] >= 60.0D) {
            estimated_activity[0] = 4.0D;
        }
        
        if(estimated_activity[0] == 4.0D && feature_element_vector[12] >= -3.5D && feature_element_vector[12] <= -1.0D && feature_element_vector[8] >= 40.0D) {
            estimated_activity[0] = 7.0D;
        }
        
        if(estimated_activity[0] == 2.0D && feature_element_vector[8] >= 20.0D) {
            estimated_activity[0] = 4.0D;
        }
        
        if(estimated_activity[0] == 3.0D && feature_element_vector[8] >= 80.0D) {
            estimated_activity[0] = 4.0D;
        }
        
        estimated_activity[1] = feature_element_vector[3];
        estimated_activity[2] = feature_element_vector[12];
        estimated_activity[3] = feature_element_vector[8];
        estimated_activity[4] = feature_element_vector[9];
        estimated_activity[5] = feature_element_vector[10];
        estimated_activity[6] = feature_element_vector[11];
        if(estimated_activity[3] > 0.0D) {
            if(estimated_activity[0] == 4.0D) {
                estimated_activity[7] = this.alpha * (feature_element_vector[13] - this.n_ampl) + this.beta * (feature_element_vector[14] - this.n_fre) + this.SL_0_walking;
            } else if(estimated_activity[0] == 6.0D && estimated_activity[0] == 7.0D) {
                estimated_activity[7] = this.alpha * (feature_element_vector[13] - this.n_ampl) + this.beta * (feature_element_vector[14] - this.n_fre) + this.SL_0_hiking;
            } else if(estimated_activity[0] == 5.0D && estimated_activity[4] > 0.0D) {
                estimated_activity[7] = this.SL_0_run;
            } else {
                estimated_activity[7] = this.alpha * (feature_element_vector[13] - this.n_ampl) + this.beta * (feature_element_vector[14] - this.n_fre) + this.SL_0_walking;
            }
        } else if(estimated_activity[0] == 5.0D && estimated_activity[4] > 0.0D) {
            estimated_activity[7] = this.SL_0_run;
        } else {
            estimated_activity[7] = 0.0D;
        }
        
        return estimated_activity;
    }
    
    public void getobject() {
        try {
            FileInputStream c = new FileInputStream(this.file_pos_class_1);
            ObjectInputStream in = new ObjectInputStream(c);
            this.s_train_1 = (svm_train)in.readObject();
            c = new FileInputStream(this.file_pos_class_2);
            in = new ObjectInputStream(c);
            this.s_train_2 = (svm_train)in.readObject();
            c = new FileInputStream(this.file_pos_class_3);
            in = new ObjectInputStream(c);
            this.s_train_3 = (svm_train)in.readObject();
            in.close();
            c.close();
        } catch (IOException var3) {
            var3.printStackTrace();
        } catch (ClassNotFoundException var4) {
            var4.printStackTrace();
        }
        
    }
    
    public void getobject(String path) {
        try {
            FileInputStream c = new FileInputStream(path + "/svm/KistracCalssifierV5_2_1.ser");
            ObjectInputStream in = new ObjectInputStream(c);
            this.s_train_1 = (svm_train)in.readObject();
            c = new FileInputStream(path + "/svm/KistracCalssifierV5_2_2.ser");
            in = new ObjectInputStream(c);
            this.s_train_2 = (svm_train)in.readObject();
            c = new FileInputStream(path + "/svm/KistracCalssifierV5_2_3.ser");
            in = new ObjectInputStream(c);
            this.s_train_3 = (svm_train)in.readObject();
            in.close();
            c.close();
        } catch (IOException var4) {
            var4.printStackTrace();
        } catch (ClassNotFoundException var5) {
            var5.printStackTrace();
        }
        
    }
}
