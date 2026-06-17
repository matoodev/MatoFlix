import SwiftUI

struct AccountView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isSignUp = true
    @State private var showPassword = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.898, green: 0.036, blue: 0.078).opacity(0.15),
                    .clear,
                    .black,
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("MATOFLIX")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color(red: 0.898, green: 0.036, blue: 0.078))
                    .tracking(5)

                Text("Unlimited movies, TV shows, and more")
                    .font(.system(size: 18))
                    .foregroundColor(Color(white: 0.8))
                    .padding(.top, 12)

                Text("Watch anywhere. Cancel anytime.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(white: 0.5))
                    .padding(.top, 4)

                VStack(spacing: 16) {
                    if isSignUp {
                        TextField("", text: $name, prompt: placeholder("Full name"))
                            .textFieldStyle(AuthTextFieldStyle())
                    }

                    TextField("", text: $email, prompt: placeholder("Email address"))
                        .textFieldStyle(AuthTextFieldStyle())

                    HStack {
                        if showPassword {
                            TextField("", text: $password, prompt: placeholder("Password"))
                                .textFieldStyle(AuthTextFieldStyle())
                        } else {
                            SecureField("", text: $password, prompt: placeholder("Password"))
                                .textFieldStyle(AuthTextFieldStyle())
                        }

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(Color(white: 0.5))
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        isLoggedIn = true
                    } label: {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.898, green: 0.036, blue: 0.078))
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)

                    if isSignUp {
                        Text("By signing up you agree to our Terms of Use and Privacy Policy.")
                            .font(.system(size: 11))
                            .foregroundColor(Color(white: 0.4))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                .background(Color(white: 0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(white: 0.1), lineWidth: 1)
                )
                .padding(.horizontal, 40)
                .padding(.top, 40)

                HStack(spacing: 4) {
                    Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(Color(white: 0.5))
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSignUp.toggle()
                        }
                    } label: {
                        Text(isSignUp ? "Sign in now." : "Sign up now.")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 20)

                Spacer()

                Text("© 2024-2026 MatoFlix, Inc.")
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.3))
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: 500)
        }
    }

    private func placeholder(_ text: String) -> Text {
        Text(text).foregroundColor(Color(white: 0.4))
    }
}

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 15))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(white: 0.12))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(white: 0.2), lineWidth: 1)
            )
    }
}
