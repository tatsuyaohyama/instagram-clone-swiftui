import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showRegisterView: Bool = false
    @State private var showIndicator: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image("instagram-text-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 240, maxHeight: 80)
                
                CustomTextField(placeholder: "メールアドレス", text: $email)
                    .padding(.vertical, 4)
                CustomSecureTextField(placeholder: "パスワード", text: $password)
                    .padding(.vertical, 4)
                
                HStack {
                    Spacer()
                    Button {
                        print("forgot password")
                    } label: {
                        Text("パスワードを忘れた場合")
                            .font(.footnote)
                    }
                }
                .padding(.vertical, 4)
                
                Button {
                    showIndicator = true
                    viewModel.login(withEmail: email, password: password) {
                        showIndicator = false
                    }
                } label: {
                    Text("ログイン")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding()
                }
                .disabled(showIndicator)
                .modifier(LoadingModifier(isLoading: $showIndicator))
                
                Spacer()
                
                HStack {
                    Text("アカウントを持っていない場合")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Button {
                        showRegisterView.toggle()
                    } label: {
                        Text("登録はこちら")
                            .font(.footnote)
                    }
                }
                
                NavigationLink(destination: RegisterView().navigationBarHidden(true), isActive: $showRegisterView) {
                    EmptyView()
                }
            }
            .padding()
            .padding(.top, -120)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
                .environmentObject(AuthViewModel.shared)
        }
    }
}
