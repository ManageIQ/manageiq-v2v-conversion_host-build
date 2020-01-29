FROM centos:8

RUN cd /etc/yum.repos.d/ && \
    curl -LO https://fedorapeople.org/groups/virt/virtio-win/virtio-win.repo && \
    curl -LO https://copr.fedorainfracloud.org/coprs/manageiq/ManageIQ-Master/repo/epel-8/manageiq-ManageIQ-Master-epel-8.repo && \
    curl \
        https://trunk.rdoproject.org/centos8/dlrn-deps.repo \
        https://trunk.rdoproject.org/centos8-master/component/clients/current/delorean.repo \
        https://trunk.rdoproject.org/centos8-master/component/common/current/delorean.repo \
        https://trunk.rdoproject.org/centos8-master/component/security/current/delorean.repo \
        https://trunk.rdoproject.org/centos8-master/component/tripleo/current/delorean.repo \
        > rdo.repo && \
    true

RUN dnf -y install \
        epel-release \
        https://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm \
    && \
    dnf -y update && \
    dnf -y install \
        nbdkit \
        nbdkit-python-plugin \
        nbdkit-vddk-plugin \
        python3-ovirt-engine-sdk4 \
        qemu-kvm \
        v2v-conversion-host-wrapper \
        virt-v2v \
        virtio-win \
    && \
    dnf -y install --enablerepo=PowerTools python3-openstackclient && \
    dnf clean all

# The container image cannot handle sparse file properly. Keep --size to the
# required minimum.
RUN /usr/bin/supermin \
        --build \
        --verbose \
        --copy-kernel \
        --format ext2 \
        --size 300M \
        --host-cpu x86_64 \
        /usr/lib64/guestfs/supermin.d \
        -o /usr/lib64/guestfs/ && \
    touch /usr/lib64/guestfs/README.fixed && \
    LIBGUESTFS_BACKEND=direct libguestfs-test-tool

RUN install --mode=0775 --group=0 -d /data && \
    install --mode=0775 --group=0 -d /data/input && \
    install --mode=0775 --group=0 -d /data/vddklib && \
    install --mode=0775 --group=0 -d /data/vm && \
    install --mode=0775 --group=0 -d /var/lib/uci && \
    install --mode=0775 --group=0 -d /var/log/uci && \
    ln -s /data/vddklib/vmware-vix-disklib-distrib /opt/vmware-vix-disklib-distrib &&\
    true

COPY entrypoint /usr/local/bin/entrypoint

VOLUME ["/opt/vmware-vix-disklib-distrib"]
ENTRYPOINT ["/usr/local/bin/entrypoint"]
USER ${USER_UID}
