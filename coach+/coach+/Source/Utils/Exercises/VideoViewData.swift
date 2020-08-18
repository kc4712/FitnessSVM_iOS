//
//  VideoViewData.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 20..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class VideoViewData {
    
    fileprivate var m_description: String = ""
    
    var Description: String {
        get {
            return m_description
        }
        set {
            m_description = newValue
        }
    }
    
    fileprivate var m_image: String = ""
    
    var ImageFileName: String {
        get {
            return m_image
        }
        set {
            m_image = newValue
        }
    }
    
    fileprivate var m_name: String = "";
    
    var CourseName: String {
        get {
            return m_name
        }
        set {
            m_name = newValue
        }
    }
    
    fileprivate var m_on: Bool = false
    
    var IsOn: Bool {
        get {
            return m_on
        }
        set {
            m_on = newValue
        }
    }
    
    init(_ description: String, _ image: String, _ name: String, _ on: Bool = false) {
        Description = description
        ImageFileName = image
        CourseName = name
        IsOn = on
    }
    
    
    static var program001 = [VideoViewData("desc.html_01", "WarmingUp_01.png", Common.ResString("neck_stretch")),
                                   VideoViewData("desc.html_01", "WarmingUp_02.png", Common.ResString("wrist_stretch")),
                                   VideoViewData("desc.html_01", "WarmingUp_03.png", Common.ResString("arms_behind_back")),
                                   VideoViewData("desc.html_01", "WarmingUp_04.png", Common.ResString("side_stretch")),
                                   VideoViewData("desc.html_01", "WarmingUp_05.png", Common.ResString("shoulder_stretch1")),
                                   VideoViewData("desc.html_01", "WarmingUp_06.png", Common.ResString("shoulder_stretch2")),
                                   VideoViewData("desc.html_01", "WarmingUp_07.png", Common.ResString("turnning_windmill")),
                                   VideoViewData("desc.html_01", "WarmingUp_08.png", Common.ResString("waist_bow"))]
    
    static var program002 = [VideoViewData("desc.html_01", "15MinutesExercise_01.png", Common.ResString("jump_and_waist_ankle_circle")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_02.png", Common.ResString("push_up")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_03.png", Common.ResString("standing_high_jump")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_04.png", Common.ResString("squat")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_05.png", Common.ResString("standing_walking")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_06.png", Common.ResString("crunches")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_07.png", Common.ResString("side_kick")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_08.png", Common.ResString("side_lunges")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_09.png", Common.ResString("jumping_jacks")),
                                   VideoViewData("desc.html_01", "15MinutesExercise_10.png", Common.ResString("abs_and_back_workout"))]
    
    static var program003 = [VideoViewData("desc.html_01", "MatExercise_01.png", "Rolling like a ball"),
                                   VideoViewData("desc.html_01", "MatExercise_02.png", "Open leg rocker"),
                                   VideoViewData("desc.html_01", "MatExercise_03.png", "Double leg pull"),
                                   VideoViewData("desc.html_01", "MatExercise_04.png", "Criss cross"),
                                   VideoViewData("desc.html_01", "MatExercise_05.png", "Swimming")]
    
    static var program004 = [VideoViewData("desc.html_01", "ActiveExercise_01.png", "Side step jacks"),
                                   VideoViewData("desc.html_01", "ActiveExercise_02.png", "Criss Cross squat"),
                                   VideoViewData("desc.html_01", "ActiveExercise_03.png", "Curtsy lunge"),
                                   VideoViewData("desc.html_01", "ActiveExercise_04.png", "Alt toe tap squat"),
                                   VideoViewData("desc.html_01", "ActiveExercise_05.png", "Squat hops")]
    
    static var program101 = [VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_01.png", "Wide squat plie"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_02.png", "Roll up"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_03.png", "Double leg circle"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_04.png", "C Curved Crunch"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_05.png", "Heel Touch"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_06.png", "Criss Cross"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_07.png", "Oblique Side band"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_08.png", "O Balance"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_09.png", "Triangle Holding"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_11_10.png", "Plank Push Up")]
    
    static var program102 = [VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_01.png", "Ballerina Wide Squat"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_02.png", "Hip Lifting"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_03.png", "Single Leg Bridge"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_04.png", "Back Extension"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_05.png", "Swimming"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_06.png", "Single Leg Circle"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_07.png", "Double Leg Kick"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_08.png", "Stand Hip Extension"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_09.png", "Lunge"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_12_10.png", "Hug A Tree Squat")]
    
    static var program201 = [VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_01.png", "Jumping Jack"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_02.png", "Arm Walking"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_03.png", "High Knee Freeze"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_04.png", "Hip Bridge"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_05.png", "Squat"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_06.png", "Push-up"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_07.png", "Heel Touch"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_08.png", "Reverse Lunge"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_09.png", "Sky Reach"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_21_10.png", "Sumo Walk")]
    
    static var program202 = [VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_01.png", "Jumping Jack"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_02.png", "SC with Reach"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_03.png", "Oblique Crunch"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_04.png", "Push-up Combo"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_05.png", "Double Deep Squat"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_06.png", "T Push-up"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_07.png", "Russian Twist"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_08.png", "Front Lunge"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_09.png", "Back Extension"),
                                   VideoViewData("desc.html_01", "batch_FitnessProgram_Screen_22_10.png", "Side Crunch")]
    
    static var program301 = [VideoViewData("desc.html_01", "FitnessProgram_Screen_31_01.png", "Side streching"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_02.png", "Spine twist"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_03.png", "Chin up"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_04.png", "Side Crunch"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_05.png", "Roll up down"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_06.png", "Cat pose"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_07.png", "Lift twist"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_08.png", "Wide squat"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_09.png", "Body balance"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_10.png", "Flying"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_31_11.png", "Bridge")]
    
    static var program302 = [VideoViewData("desc.html_01", "FitnessProgram_Screen_32_01.png", "Roll up"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_02.png", "Hip kick"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_03.png", "Hack squat"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_04.png", "Deep lunge"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_05.png", "Lunge kick"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_06.png", "Jumping squat"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_07.png", "Boat"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_08.png", "Flying"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_09.png", "Lunge press"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_10.png", "Hyper extension"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_11.png", "Step squat"),
                                   VideoViewData("desc.html_01", "FitnessProgram_Screen_32_12.png", "Lift&twist")]
}
