//
//  GCDBlackBox.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/17/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
