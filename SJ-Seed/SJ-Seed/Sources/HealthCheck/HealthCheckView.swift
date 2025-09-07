//
//  HealthCheckView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/8/25.
//

import SwiftUI
import Moya

struct HealthCheckView: View {
    @StateObject private var vm: HealthCheckViewModel
    @State private var isLoading = false

    init(vm: HealthCheckViewModel = HealthCheckViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack(spacing: 16) {

            Group {
                if let model = vm.model {
                    Text("Server Status: \(model.status)")
                        .font(.headline)
                } else if let err = vm.errorMessage {
                    Text("Error: \(err)")
                        .foregroundStyle(.red)
                } else {
                    Text("Not checked yet")
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                vm.check()
            } label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(height: 20)
                } else {
                    Text("Check Now")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .padding()
    }
}

#Preview {
    let stubProvider = MoyaProvider<HealthAPI>(stubClosure: MoyaProvider.immediatelyStub)
    let service = HealthService(provider: stubProvider)
    let vm = HealthCheckViewModel(service: service)
    return HealthCheckView(vm: vm)
}
