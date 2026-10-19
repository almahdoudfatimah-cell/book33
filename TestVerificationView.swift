import SwiftUI

struct TestVerificationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("🔥🔥🔥 TEST VIEW 🔥🔥🔥")
                .font(.system(size: 40, weight: .black))
                .foregroundStyle(.red)
            
            Text("If you see this, Xcode IS compiling new code!")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("The problem is somewhere else")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

#Preview {
    TestVerificationView()
}
