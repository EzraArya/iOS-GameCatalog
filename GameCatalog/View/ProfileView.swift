import SwiftUI

struct ProfileView: View {
    @AppStorage("name") private var name = "Ezra Arya Wijaya"
    @AppStorage("email") private var email = "ezrawijaya10@gmail.com"
    @State private var isPresented = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                VStack {
                    Image(.foto)
                        .resizable()
                        .scaledToFit()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                        .shadow(radius: 10)
                        .clipShape(.capsule)
                        .frame(width: 200, height: 200)
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.title.bold())
                            .foregroundStyle(.primary)
                        Text(email)
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                    Spacer()
                }
            }
            .toolbar {
                Button("", systemImage: "plus") {
                    isPresented = true
                }
            }
            .sheet(isPresented: $isPresented) {
                Form {
                    VStack {
                        TextField("Enter Name", text: $name)
                        TextField("Enter Email", text: $email)
                        Button("Dismiss") {
                            isPresented = false
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
