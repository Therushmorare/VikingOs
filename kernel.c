// kernel.c
void main() {
    char* video = (char*) 0xb8000;
    video[0] = 'K';
    video[1] = 0x07; // White on black
}
